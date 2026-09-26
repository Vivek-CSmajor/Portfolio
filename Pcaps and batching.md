In the obscure no mans land of SIP trunking and telecom/telephony infra, engineers fiddling through a rainbow of logs, RTP packets, audio streams, and SIP headers to pinpoint the source of the bugs and troubleshoot and analyze metrics like jitter, packet loss, latency to diagnose static, one way audio and dropped calls in a cry for help invented PCAP aka Packet Capture format (.pcap) originally for the tcpdump packet analyzer. Later recognised as one of the accepted formats by Wireshark, which uses pcap files to decode, visualize, and troubleshoot SIP (Session Initiation Protocol) signaling and related media streams, which sort of looks like this (or at least it did in the 2000s)

![[Pasted image 20260920232050.png]]


## The requirement

Now that you know why companies might need these files, lets go back to something i did the past couple of weeks and walk you through how stupid i am.

So at Vobiz AI we needed to have these files for a bunch of reasons including the ones above and regulatory compliance and fraud detection for every call that goes through our SIP trunking infra.

Each file needed to be available for download from an S3 bucket.

## How to capture the packets and create pcap files?

We need something to sniff for packets flowing through our servers, which is where an open source tool like VoIPmonitor packet sniffer comes into play, that sniffs for VoIP protocols such as our beloved SIP, on deployed Linux servers and compresses them to convert into the pcap format. Fun fact, it introduces 0 latency in the call flows since it works like a passive listener.

Along with that we needed something custom to move those captured new pcap files from the captured directories and automatically upload them to an S3 bucket. Which is what we created and call the pcap uploader service.

These two together are deployed directly on EC2 instances, why? Because VoIPmonitor needs to live within the server to capture calls, and it made sense to have the pcap uploader deployed together with it, otherwise its just an extra network hop that we can simply avoid.

## The issue

Initially the uploader uploaded all files to the S3 bucket individually, now mind you, we handle 5 million+ calls a day, and each comes with its own pcap files and sometimes due to multiple hops between servers there are multiple pcap files from each capture point (server).

Which came to roughly around 7 million PUTs each day on the S3 bucket. And S3 doesnt charge you by object size, it charges by number of requests. So 7 million large files is the same cost as 7 million small ones (ignoring the storage costs). And PCAP files are mostly in a couple hundred KBs of size.

All in all we kept on paying a massive bill (in lakhs every month) just to put a file in S3, even with a 3 day lifecycle rule.

And since its a regulatory requirement we cannot afford to lose or drop any file.

## The solution

Instead of putting each file on creation into the S3 bucket, how about we batch it? Say 1 minute archives and upload it to S3. Do the math and it comes out to be 1440 PUTs per day per host. But it wont be 1440. It will be more than that, why? We will come back to that a bit later.

#### Architecture design options considered

Now blessed with this glorious purpose, me and my 2 braincells came up with approximately 4 approaches, heres a quick overview of each.

But before that u should know why this is even a problem, how does one find a single calls PCAP file now? Earlier a simple request to S3 for each file was an easy peasy task because each file was named by its call id, so call id to S3 key addressing just worked. The second u start batching multiple files into one .tar, that addressing is not an option anymore, u no longer have 1 file = 1 key, u have N files sitting inside 1 key, so now u need some way to say which archive and where inside it.

Whats a tape archive? Tar is just a container. Takes multiple files, concatenates into one. No compression!

So a naive approach would be to just archive the files of each minute into .tar and put to S3. But that would be a huge file, so now u need compression. But but, an even naiver approach would be to compress the entire .tar, say using gzip, into one large .tar.gz. Which is stupid af because gzip compression works by finding patterns across the whole stream its compressing. Once the whole archive is one continuous gzip stream, you cannot decompress just the middle of it, youd have to download and decompress the entire 139 MB (assumed size of a .tar after a minute of pcap files) file just to get one 149 KB capture back out. That defeats the entire point of fast, cheap single call lookups. So the actual move is compress each file individually first, then tar them together, that way every file inside is its own independent gzip stream, and a byte range read plus 1 decompress gets you exactly that 1 file back.

Ok so with that out the way, heres the actual addressing problem laid out as options, same way ud lay it out for any system where u batch small things into 1 big thing (this is basically the same problem as Kafka segments or video chunking, not just a pcap thing):

**Option A. Uploader writes directly and synchronously to Postgres.** Rejected: gives the uploader a brand new dependency, a DB connection sitting directly in its critical path. And because i m a sucker for "simple low infra appraoches" I disregarded it outright.

**Option B. Async write via a local WAL, a separate process tails it into Postgres.** Rejected as unnecessary complexity once Postgres latency/availability was no longer treated as a design constraint; it existed specifically to hedge against slow/unreachable Postgres.

**Option C. S3 manifest (sidecar JSON per archive) as source of truth, Postgres as a query cache.** Chosen initially. Kept the uploaders dependency footprint at S3 only; manifest inherited the existing 3 day lifecycle rule automatically (no separate TTL logic needed); rebuild from S3 was "replay manifests" rather than re parsing tar headers.

**CDR timestamp derivation as a primary index.** Considered and rejected as a sole mechanism (only narrows to an archive, doesnt give byte offset, and boundary case ambiguity at minute rollovers was judged too weak for a regulatory weight guarantee); retained later as a fallback lookup path.

Now initially I went with the S3 manifest sidecar JSON per archive approach without the DB at all. Reason? I believed since every call has a call id (well, an end time) I could simply derive the time window, go straight to that minutes manifest, find the call in it, grab the byte offset plus length, and do a ranged GET for just that call, no DB, no separate service to keep in sync, no cache to ever rebuild. Manifest sits right next to its archive in S3, so the same 3 day lifecycle rule deletes both automatically. Free TTL basically. I was very proud of myself.

For calls that end right on a minute boundary, the lookup just also checks the adjacent minute as a fallback. Only moving part left was a small reconciliation job for the 1 case this cant avoid on its own, uploader crashes after uploading the archive but before writing the manifest, leaves an orphan archive nobody can find.

Which is actually an issue, because its a compliance problem. You cant afford to lose a pcap file.

## In an investigation, assumptions kill
[[Sassy Told You So GIF by Amazon Prime Video.gif]]
The 6 5' 250 pounds white dude was right. My assumption that killed my whole week of effort was that all calls have a CDR.

Nope, they dont exist.

And I built my entire manifest.json approach on one flow: get call_id, find its CDR, grab timestamp, figure out which minutes archive to open.

So my "derive the archive minute" trick just jumped off the cliff.

This was a Goddamn genius approach if only all calls had a CDR. But fuck it.

## Krishnas eternal wisdom
[[Insert Ram Ram Hindu GIF]]
After a bit of fucking around and finding out i figured out, the simplest approach is the best approach even if it adds more dependent infra. The simple archive index table in the DB giving path to each pcap file in S3. Boooommmm it works.

## Lil bugs on the way
[[Insert Black and white Art GIF by Doris Wopereis]]
So the archive naming scheme was dead simple: `<capture_point>/<date>/archive-<hour><minute>.tar`. One folder per host type (like mediaserver, media proxy), one file per minute. Made sense... if there was only one server per capture point.

There werent, there were ahem ahem 30+ instances and hosts, and a total of 5 6 S3 prefixes they were all writing to. Which meant many of the instances were writing to the same folder within the same minute simultaneously.

This caused an overwrite issue that took me quite a while to grasp. Suppose two hosts write to the same minute, the one that wrote last overwrote the previous ones archive, which basically meant the previous hosts last minutes archives are forever undiscoverable. Because in S3 they dont exist, only in the table they do.

How did i know? I downloaded the whole archive, listed whats actually inside it, and the file I wanted wasnt even in there even though it should have been written to that exact minutes archive because i made the call exactly then.

### My duct tape?
[[Insert This is the end reaction GIF]]
A one liner, put the actual servers name in the archive filename. So `archive-0909-ip-10-1-36-8.tar` instead of `archive-0909.tar`.

Hehehehe i m such a geniusss!!

### Cleanup when u take a dump
[[Insert GIF by Achiloid]]
Millions of pcap rows coming into the table would bloat it way too much. The size would be ginormous, especially with an index on it. We got nothing to worry about on S3, since it has a lifecycle rule for 3 days already.

Where should the cleanup live? I am a genius on this topic considering the amount of times i have had to make this decision now. Which is thrice heehehe.

So my very simple on the nose solution was a Lambda function that runs at midnight during low traffic and wipes out the rows older than 3 days.

Where it shouldnt live? Deffo not on the servers.

### Making sure the pills work

Before shaming myself in office and getting almost fired, I decided to test it out properly myself. Built a fake version of the entire setup locally, fake S3, throwaway database, and multiple fake servers all hammering the same capture point at once, way harder than real traffic ever does. Then i killed one of them mid write, on purpose, just to see if itd lose data or handle it gracefully.

Also did the thing where you break your own fix on purpose just to make sure your test would actually catch it.

And finally tested a demo call server which didnt have pcap enabled on it and very low impact traffic. Everything passed.

## Did it work?

Hell Yeah.
$80+ a day in S3 request costs to $1 $2 a day.

97.7% fewer requests. Across the entire fleet. In actual production. Not a lab number, real billing data, pulled straight from AWS days after the full rollout.

[[Insert minions mic drop gif here]]

![[Minions Mic Drop GIF 3.gif]]