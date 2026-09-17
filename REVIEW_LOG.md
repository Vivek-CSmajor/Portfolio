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

