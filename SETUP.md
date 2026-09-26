# Setup

Identity-dependent values are centralized in `src/config/site.config.ts`.
Nothing else in the codebase should need to change once these are filled in.

| Placeholder            | Where it's used                          | Replace with |
|-------------------------|-------------------------------------------|--------------|
| `YOUR_GITHUB_USERNAME`  | GitHub contribution graph, GitHub link    | Your GitHub username |
| `YOUR_LINKEDIN_USERNAME`| LinkedIn link in Contact section          | Your LinkedIn profile username |

Also check:
- `resumeUrl` in `site.config.ts` points to `/resume.pdf` — drop an actual
  resume PDF into `public/resume.pdf` (the file doesn't exist yet, so the
  link is currently dead).
- `email` in `site.config.ts` is already real (vivek.csmajor@gmail.com) —
  update it there if it ever changes.
