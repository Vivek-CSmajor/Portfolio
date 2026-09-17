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

