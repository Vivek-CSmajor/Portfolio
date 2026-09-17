export interface Post {
  slug: string;
  title: string;
  date: string; // ISO date
  teaser: string;
  body: string[];
}

export const posts: Post[] = [
  {
    slug: "go-gin-patterns",
    title: "Go + Gin Patterns I Keep Reaching For",
    date: "2026-08-14",
    teaser:
      "Middleware, error handling, and project layout conventions that held up once things got messy at work.",
    body: [
      "Most Gin codebases start clean and then rot the moment two routes need the same auth check and a third needs a slightly different one. The pattern that's held up for me is keeping every cross-cutting concern — auth, logging, request-id propagation — as its own middleware, composed explicitly per route group rather than registered globally and special-cased later.",
      "Error handling follows the same idea: handlers return a typed error, and a single middleware at the top of the chain maps that error to an HTTP status and response body. Handlers never write error responses themselves. That one rule has removed almost all the inconsistent error JSON I used to ship.",
      "Project layout: a `handler` package per resource, a `service` package that holds the actual logic and is what gets unit tested, and `main.go` doing nothing but wiring. Gin stays at the edge; nothing below the handler layer imports `gin` at all.",
    ],
  },
  {
    slug: "offline-judging-engine",
    title: "Building an Offline Judging Engine",
    date: "2026-07-02",
    teaser:
      "Architecture walkthrough of the sandboxed execution and ICPC-style scoring behind the coding assessment platform.",
    body: [
      "The constraint that shaped everything: the platform has to keep running a full exam even if the internet does not exist for the next two hours. That rules out any architecture where grading calls out to a cloud sandbox.",
      "So the judging engine runs entirely on the local exam machine — a lightweight local control plane that syncs problem sets and roster data from the cloud before the exam starts, then judges every submission locally against ICPC-style test cases, and syncs results back once connectivity returns.",
      "Sandboxing submitted code on a machine you don't fully control is the hard part: resource limits (CPU time, memory, process count), no network namespace, and a filesystem view that can't see anything outside the submission's own scratch directory. Getting this right mattered more than making the scoring algorithm clever.",
    ],
  },
  {
    slug: "sip-voip-integrations",
    title: "What I Learned Building SIP/VoIP Integrations",
    date: "2026-05-20",
    teaser:
      "Notes from wiring up monitoring for real-time call infrastructure — the parts the RFC doesn't warn you about.",
    body: [
      "SIP looks simple on paper — INVITE, 200 OK, ACK — until you're the one debugging why a call dropped for one specific carrier route at 2am. The RFC tells you the state machine; it does not tell you which vendors interpret re-INVITEs differently.",
      "The monitoring that actually caught problems before customers did was less about SIP signaling and more about the media layer: RTP packet loss, jitter, and one-way-audio detection. Alerting on call-setup failures alone missed an entire class of 'the call connected but was unusable' incidents.",
      "The biggest lesson: treat every third-party SIP trunk as if it will violate the spec in some small way, and build monitoring that surfaces that violation quickly rather than trying to preemptively handle every vendor's quirks in code.",
    ],
  },
];
