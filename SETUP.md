# Portfolio setup

This Astro site keeps the original newspaper design: paper texture, black rules, and the original display fonts. The homepage's hero, skills, and contact sections are in `src/pages/index.astro`; their small layout additions are in `src/styles/global.css`.

Run `npm ci`, then `npm run dev` for local development. Run `npm run build` to generate the static site in `dist/`.

## Personal links

Edit `src/config/site.config.ts` to change the GitHub username, LinkedIn profile, email, or résumé URL. The current profile values are configured there.

The résumé URL is `/resume.pdf`, but that file has not been supplied. Add the actual résumé as `public/resume.pdf`, then rebuild. The site will change from “Request résumé” (email) to the document link automatically. A full HTTPS résumé URL also works.

The featured project's repository URL is not known. Its link currently opens the existing architecture article, so it does not lead to a dead end.

## Content and logos

Blog posts are in `src/content/blog/`. Branded technology marks are local assets in `public/icons/`, shown beside readable text labels. The live GitHub contribution chart is loaded by `src/components/GithubGraph.astro`.

For a restricted Windows shell where Astro telemetry cannot create its config directory, set `$env:ASTRO_TELEMETRY_DISABLED='1'` before using the npm commands.
