# Review Log

## Iteration 1 — GitHub contribution graph component

**Checklist item:** "GitHub contribution graph component built and wired
to a config placeholder... renders correctly with the placeholder value,
ready to go live the moment a real username is dropped in."

**What changed:**
- Added `src/config/site.config.ts` holding `githubUsername`,
  `leetcodeUsername`, `linkedinUrl`, `githubUrl`, `email`, `resumeUrl` —
  the identity-dependent values, with `YOUR_*` placeholders for the ones
  not yet known.
- Added `src/components/GithubGraph.astro`: renders a styled placeholder
  grid (newspaper-style skeleton squares + caption) when
  `githubUsername` is still the placeholder; renders a live
  `ghchart.rshah.org` contribution-graph image (lazy-loaded) once a real
  username is set, with an `onerror` fallback to text instead of a
  broken image.
- Added a "GitHub Activity" section to `index.astro` between Skills and
  Blog, using the new component.
- Routed the previously-hardcoded résumé/email/LinkedIn/GitHub links in
  the nav and Contact section through `site.config.ts` instead of
  inline `"#"` / hardcoded strings, per the standing rule that
  identity-dependent values must never be hardcoded in a component.
- Added `SETUP.md` listing every placeholder and what to replace it
  with.
- Initialized the git repo (none existed yet) and committed the
  pre-existing homepage as a baseline commit before this change.

**Verified:** Started the existing dev server (port 4321), loaded the
page with Playwright, screenshotted the full page and the "GitHub
Activity" section specifically, and confirmed zero console errors.
Confirmed via `$$eval` that the Contact section's anchors now render the
config values (`mailto:vivek.csmajor@gmail.com`,
`https://linkedin.com/in/YOUR_LINKEDIN_USERNAME`,
`https://github.com/YOUR_GITHUB_USERNAME`, `/resume.pdf`).

**Self-grade: Done.** The component exists, is wired to the config
placeholder, renders a clean intentional-looking placeholder (not a
broken image or blank space), and is lazy-loaded via `loading="lazy"`
on the `<img>` path. Matches the checklist bullet's wording closely.

**Follow-up needed:**
- LeetCode stats graph is still not built (separate checklist item,
  config field for it already exists as `leetcodeUsername`).
- `resumeUrl` points to `/resume.pdf` but that file doesn't exist in
  `public/` yet — the résumé link is currently dead until a real PDF is
  added (noted in `SETUP.md`).
- Haven't yet added the async/skeleton requirement from the "Technical/
  UX baseline" section beyond `loading="lazy"` — worth revisiting once
  a real username is live to confirm perceived load behavior.

## Iteration 2 — LeetCode stats graph component

**Checklist item:** "LeetCode stats graph component built and wired to
a config placeholder the same way — renders correctly with the
placeholder, ready to go live the moment a real username is dropped
in."

**What changed:**
- Added `src/components/LeetcodeGraph.astro`, mirroring the GitHub
  graph component's pattern: when `siteConfig.leetcodeUsername` is
  still the `YOUR_LEETCODE_USERNAME` placeholder, renders a styled
  placeholder — a row of 5 stat tiles (Solved / Easy / Medium / Hard /
  Ranking, each showing "—") plus a caption pointing at
  `site.config.ts` — instead of a blank space or broken image. Once a
  real username is set, it renders a live `leetcard.jacoblin.cool` SVG
  stats card (lazy-loaded `<img>`), with an `onerror` fallback to text.
- Wired it into the existing "GitHub Activity" section on the homepage
  as a second "LeetCode Stats" subsection (reused the section rather
  than adding a new one, since both are the same kind of "coding
  activity" content and the checklist doesn't require separate
  sections).
- No changes to `site.config.ts` were needed — `leetcodeUsername` was
  already defined there from iteration 1.

**Verified:** Dev server was already running on port 4321. Loaded the
page with Playwright, screenshotted the `#activity` section (now
containing both graphs), and confirmed zero console errors. Screenshot
shows both the GitHub placeholder grid and the new LeetCode stat-tile
placeholder rendering cleanly, matching the site's newspaper aesthetic.

**Self-grade: Done.** The component exists, imports the username from
the shared config (never hardcoded), renders a clean intentional
placeholder state with no console error or broken image, and needs no
code change once a real LeetCode username is dropped into
`site.config.ts` — only the `leetcard.jacoblin.cool` URL will start
resolving to real data.

**Follow-up needed:**
- Both graph components currently rely on third-party image services
  (`ghchart.rshah.org`, `leetcard.jacoblin.cool`) rather than a
  self-hosted fetch — worth flagging to the user as an external
  dependency risk, though it's the standard pattern for this and keeps
  the site static/serverless.
- `resume.pdf` is still missing from `public/` (carried over from
  iteration 1).
- All remaining checklist items (Blog preview date/link, Education
  on About page, Contact block placement, Footer, all psychological
  principles, and technical/UX baseline items) are still unchecked.

## Iteration 3 — Blog preview (title + date + link)

**Checklist item:** "Blog preview (2-3 latest posts, title + date +
link)."

**What changed:**
- Added `src/data/posts.ts`: a shared data module holding the 3 blog
  posts as `{ slug, title, date, teaser, body }`, replacing the
  title/teaser-only array that was previously inlined in `index.astro`
  with no date and no link target. Dates and body content are regular
  editorial content (not identity-dependent), so they're written
  directly rather than routed through `site.config.ts`.
- Added `src/pages/blog/[slug].astro`: a static route
  (`getStaticPaths`) that renders each post as a full page — date,
  title, body paragraphs, and a "Back to Home" link — styled
  consistently with the homepage (same fonts, borders, spacing).
- Updated the homepage's "From the Blog" section to source posts from
  the shared data module, sort by date descending, take the latest 3,
  show a formatted date under each title, and add a "Read More →" link
  to `/blog/{slug}` — so the preview now has all three required
  elements instead of just title + teaser.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright, screenshotted the `#blog` section (shows date + title
+ teaser + working link for all 3 posts), then followed the actual
rendered link (`/blog/go-gin-patterns`) and screenshotted the
destination page — it renders the full post with no console errors on
either page.

**Self-grade: Done.** All three required elements (title, date, link)
are present, sorted correctly by recency, and the link is a real,
working destination rather than a placeholder `#` — this also removes
what would otherwise have counted as a dead link in the Footer/
technical-baseline checks later.

**Follow-up needed:**
- There's no `/blog` index/listing page yet — only individual post
  pages exist, reachable currently only from the homepage preview.
  That's fine for this checklist bullet (which only requires the
  homepage preview), but the "Nav is present and consistent across
  home/blog/projects/about" item will need a real blog listing page
  and shared nav component; deferred to that item's own iteration.
- Blog post pages use a minimal ad hoc header ("← Back to Home") rather
  than the full site nav — intentional, to avoid solving nav
  consistency in this iteration.

## Iteration 4 — Education (compact on homepage, full detail on About)

**Checklist item:** "Education: one compact line on homepage, full
detail on About."

**What changed:**
- Added `src/pages/about.astro`: a new page with an `#education`
  section giving the full detail — degree name, institution, location,
  timeline (2024–2028, expected), CGPA, and one descriptive sentence —
  all drawn from confirmed facts (nothing invented beyond what was
  already on the homepage). Styled consistently with the rest of the
  site (same fonts/borders/spacing), with a minimal "← Back to Home"
  link rather than the full site nav, matching the same ad hoc-header
  approach used for blog post pages in iteration 3.
- Updated the homepage's compact education line to add a "Full Detail
  →" link pointing to `/about#education`, so the compact line and the
  full detail page are actually connected rather than the About page
  being an orphaned, unreachable route.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright, located the actual rendered `/about#education` link,
followed it, and screenshotted the resulting About page — the
Education section renders with all the detail fields, correctly
anchored, no console errors on either page.

**Self-grade: Done.** The compact line already existed on the
homepage from before this loop started; this iteration added the
missing half — a real, linked About page with the fuller detail.
Both halves of the checklist bullet are now satisfied.

**Follow-up needed:**
- The About page currently contains only the Education section — no
  broader bio/intro beyond the page header. That's intentional scope
  control for this bullet, but if a future checklist item calls for a
  fuller About page (bio, etc.), this page will need to grow rather
  than be replaced.
- Same nav-consistency deferral as blog pages: About uses an ad hoc
  back-link, not the shared site nav — to be resolved together with
  the "Nav is present and consistent across home/blog/projects/about"
  item.

## Iteration 5 — Contact block visible above the fold

**Checklist item:** "Contact block: email, LinkedIn, GitHub, resume
link — visible above the fold or in a persistent nav, not buried only
in the footer."

**What changed:**
- Added Email, LinkedIn, and GitHub links to the existing top utility
  nav in `index.astro` (which sits at the very top of the page, before
  any scrolling), alongside the Résumé button that was already there.
  All three pull from `siteConfig` (`email`, `linkedinUrl`,
  `githubUrl`) — no new hardcoded values.
- Did not touch the full Contact section further down the page (still
  present, unchanged) — this was purely about making the same four
  contact methods reachable above the fold too, per the checklist's
  "visible above the fold OR in a persistent nav" phrasing. Chose
  "above the fold" (plain text links in the existing top nav) over
  making the nav `position: sticky`, since sticky-scroll behavior
  wasn't asked for and would be a restyle beyond this bullet's scope.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright at both 1280px and 375px viewports, took a screenshot
of the viewport only (no scrolling, i.e. exactly what's "above the
fold"), and confirmed via `$$eval` that all four nav links resolve to
the correct `mailto:`, LinkedIn, GitHub, and resume URLs. No console
errors at either width, no wrapping/overlap issues on mobile (nav
items wrap onto their own lines cleanly instead of overflowing).

**Self-grade: Done.** All four contact methods (email, LinkedIn,
GitHub, résumé) are now visible in the first viewport a visitor sees,
satisfying the "above the fold" branch of the requirement directly,
without needing sticky-nav behavior.

**Follow-up needed:**
- The nav is not sticky, so on a long scroll session (e.g. reading the
  blog preview near the bottom) a visitor would need to scroll back up
  to reach these links — the checklist's "or in a persistent nav"
  branch would close that gap, but that's a UX polish choice beyond
  what this bullet strictly requires, and is a candidate for a later
  polish-pass iteration rather than this one.
- The bottom Contact section (`#contact`) still duplicates these same
  four links by design (kept as-is, unchanged) — worth confirming this
  duplication reads as intentional reinforcement rather than
  redundant when the "Consistency" psychological-principle item is
  reviewed.

## Iteration 6 — Footer (copyright, socials, no dead links)

**Checklist item:** "Footer: copyright, socials, no dead links."

**What changed:**
- The footer previously had no copyright line and no social links at
  all — just "No. 001", a decorative seal, and "September 2026".
  Added a second row below it (separated by a border, matching the
  site's rule-line motif): `© {currentYear} Vivek Pandey. All rights
  reserved.` on the left, and Email/LinkedIn/GitHub links on the
  right.
- `currentYear` is computed with `new Date().getFullYear()` at build
  time rather than hardcoded, so the copyright year doesn't go stale.
- Email/LinkedIn/GitHub links pull from `siteConfig` (same pattern as
  the top nav and Contact section) — no new hardcoded values, and
  LinkedIn/GitHub correctly resolve to the `YOUR_LINKEDIN_USERNAME` /
  `YOUR_GITHUB_USERNAME` placeholders rather than a broken `#` or an
  invented username.
- Left the original top row (No. 001 / seal / date) untouched.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright, screenshotted the `<footer>` element specifically,
and confirmed via `$$eval` that all three footer links resolve to the
expected `mailto:`, LinkedIn, and GitHub URLs (the config placeholders,
not `#`). Zero console errors.

**Self-grade: Done.** Footer now has all three required elements:
copyright text, socials, and no dead (`#`) links — the LinkedIn/GitHub
links point at the intentional config placeholders, which is the
correct state per this loop's standing instruction, not a defect to
fix.

**Follow-up needed:**
- None specific to this item. The footer's social links duplicate the
  top-nav and Contact-section links, which is consistent with how
  those were already handled in iteration 5 — same open question about
  whether that's read as reinforcement or redundancy, deferred to the
  "Consistency" principle review.

## Iteration 7 — Hero (name + one clear positioning line)

**Checklist item:** "Hero: name + one clear positioning line (not
generic 'aspiring dev')."

**What changed:** Nothing — this content already existed in the
pre-loop baseline homepage and was verified rather than reimplemented.
Flagged in iteration 6's follow-up: this item (along with Short intro,
Featured work, and Tech stack) was left unchecked in
`REVIEW_CHECKLIST.md` even though the underlying content was already
present, because iteration 1 judged it satisfied without formally
checking it off. This iteration closes that gap for Hero specifically.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright and confirmed via direct DOM read: the `<h1>` renders
"Vivek Pandey" as the single largest, most visually dominant element
on the page (display font, up to 9xl, centered, first thing after the
nav), and the subhead banner directly below it reads "Backend
Developer — Go, AWS, and the Systems Underneath Telephony/VoIP" — a
specific, concrete positioning statement naming real technologies and
a domain focus, not a generic "aspiring developer" placeholder.
Screenshot confirms visual hierarchy matches. Zero console errors.

**Self-grade: Done.** Both required elements (name, one clear
positioning line) are present and satisfy the bullet's explicit
"not generic" constraint. No code change was necessary.

**Follow-up needed:** None for this item. Two more items from the
same iteration-6 flag remain to be verified-and-checked in future
iterations: "Short intro" and "Featured work section" / "Tech stack
section" — next up per checklist order is Short intro.

## Iteration 8 — Short intro (2-4 sentences, role + focus area named)

**Checklist item:** "Short intro (2-4 sentences), current role +
focus area named."

**What changed:** Nothing — same situation as iteration 7. The lede
paragraph already existed in the pre-loop baseline and was verified
against this specific bullet rather than reimplemented.

**Verified:** Dev server running on port 4321. Loaded the homepage
with Playwright, extracted the lede paragraph's text directly from the
DOM, and counted sentences programmatically: 3 sentences (within the
2-4 range) — "Currently a backend engineering intern at Vobiz.ai,
working on core messaging infrastructure (SMS/RCS) and AI voice agent
tooling for an AI-first telephony platform. CS undergrad at Amity
University, Lucknow. Language-agnostic by design — Go is home base,
but the interesting part is the systems, not the syntax." Current role
("backend engineering intern at Vobiz.ai") and focus area (messaging
infrastructure, AI voice agent tooling, telephony platform) are both
explicitly named. Screenshot confirms rendering. Zero console errors.

**Self-grade: Done.** All required elements present: sentence count
in range, role named, focus area named. No code change was necessary.

**Follow-up needed:** One item remains from the iteration-6 backlog:
"Featured work section" and "Tech stack section" still need the same
verify-and-checkoff pass — next up per checklist order.

