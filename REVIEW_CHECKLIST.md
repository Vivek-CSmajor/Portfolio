# Portfolio Review Checklist

Used by the iteration loop: each round, pick the highest-priority unchecked
item, fix it, verify with a screenshot, then check it off in
`REVIEW_LOG.md` (not this file — this file stays the master list).

## Structure & content (does it have the right things)
- [ ] Hero: name + one clear positioning line (not generic "aspiring dev")
- [ ] Short intro (2-4 sentences), current role + focus area named
- [ ] Featured work section: 3-5 highlights max, each with impact framing
      (not just a tech list)
- [x] Tech stack section: grouped by category (languages / frameworks /
      cloud / other), using real downloaded icon assets (see "Icon &
      logo assets" below), not plain text labels or emoji
- [ ] GitHub contribution graph component built and wired to a config
      placeholder (see "Placeholder-ready integrations" below) — renders
      correctly with the placeholder value, ready to go live the moment a
      real username is dropped in
- [ ] LeetCode stats graph component built and wired to a config
      placeholder the same way — renders correctly with the placeholder,
      ready to go live the moment a real username is dropped in
- [ ] Blog preview (2-3 latest posts, title + date + link)
- [ ] Education: one compact line on homepage, full detail on About
- [ ] Contact block: email, LinkedIn, GitHub, resume link — visible above
      the fold or in a persistent nav, not buried only in the footer
- [ ] Footer: copyright, socials, no dead links

## Psychological / persuasion principles
- [ ] **Visual hierarchy** — the single most important thing on each
      screen is the most visually dominant thing (size/weight/contrast),
      not competing with secondary content
- [ ] **F-pattern / Z-pattern scan support** — key info (name, role, CTA)
      sits where eyes naturally land first, not buried mid-page
- [ ] **Cognitive load** — no page asks the visitor to process more than
      ~1 primary idea + a few supporting details at once
- [ ] **Social proof / credibility signals** — real numbers used where
      available (contribution streaks, LeetCode solved count, internship
      company names) rather than vague claims
- [ ] **Consistency** — spacing scale, color usage, and type sizes repeat
      predictably across sections; nothing is a one-off snowflake style
- [ ] **Progressive disclosure** — homepage teases, detail pages deliver;
      no wall-of-text sections that could be a linked-out subpage instead
- [ ] **Clear next action** — at least one obvious "what should I do now"
      per screen (view project, read post, contact) — never a dead end
- [ ] **Whitespace as a feature** — sections have breathing room; density
      is a deliberate choice, not a leftover of not deciding on spacing

## Visual polish / creative beautification
The first pass tends to play it safe — technically correct, visually flat.
These items exist specifically to push past that:
- [ ] At least one section has a genuinely distinctive visual treatment
      beyond "card in a grid" — an unusual layout, an interesting hover/
      reveal interaction, an asymmetric composition, a typographic moment
      (a huge stat number, an oversized quote) — something a generic
      template wouldn't have
- [ ] Micro-interactions exist somewhere (hover states that do more than
      change opacity, a subtle transition on scroll, an animated
      underline) — small, tasteful, not gimmicky
- [ ] The color palette and type scale from the established design
      direction are used more expressively in at least one section —
      e.g. a bold color block, a large display-type moment — rather than
      applied uniformly and cautiously everywhere
- [ ] A design pass has been made explicitly asking "what would make a
      visitor stop scrolling for a second here?" for the hero and one
      other section, and something was changed as a result
- [ ] Nothing here breaks the established design system (colors/fonts/
      spacing tokens) — creative means bolder use of the existing
      language, not a clashing new one

## Icon & logo assets
- [ ] Tech stack icons and any relevant tool/platform logos (GitHub,
      LeetCode, socials) are actual downloaded SVG assets in the project
      (e.g. `/public/icons/`), not inline emoji or missing entirely
- [ ] Prefer monochrome/black-and-white icon sets so they read as part of
      one visual system rather than a mismatched row of brand colors —
      **Simple Icons** (simpleicons.org) is a good source: every logo is
      available as a plain SVG and can be recolored via CSS
      (`fill: currentColor`) to match the site's ink/accent color, either
      downloaded directly or via `npm install simple-icons` and imported
      per-icon
- [ ] Icons are sized and aligned consistently (same viewBox handling,
      same optical size) — not a mix of oddly-scaled logos
- [ ] Each icon has an accessible label (alt text / aria-label), not just
      a bare image

## Technical/UX baseline
- [ ] Responsive at mobile width (375px) — no horizontal scroll, no
      overlapping elements
- [ ] Page load isn't blocked by the GitHub/LeetCode graph fetch (async/
      lazy-load, with a skeleton or fallback state)
- [ ] Color contrast passes basic readability (dark text on light bg or
      vice versa, no low-contrast gray-on-gray body text)
- [ ] Nav is present and consistent across home/blog/projects/about
- [ ] No console errors on page load

## Placeholder-ready integrations
Real GitHub/LeetCode usernames aren't available yet. Don't block on them —
build these so they're one edit away from live:
- [ ] A single config file (e.g. `site.config.ts` / `config.json`) holds
      `GITHUB_USERNAME` and `LEETCODE_USERNAME` (and any other
      identity-dependent value — resume link, socials) as named constants,
      each set to an obvious placeholder like `"YOUR_GITHUB_USERNAME"`
- [ ] Every component that needs one of these values imports it from that
      config file — never hardcodes a username directly in a component
- [ ] The GitHub/LeetCode graph components render a clean, styled
      "placeholder" state when the config still holds the placeholder
      string (not a broken image or console error), so the site looks
      finished even before real IDs are dropped in
- [ ] A short `SETUP.md` (or a clearly marked section in the project
      README) lists every placeholder value in the config file and what
      to replace it with — this is the actual handoff doc for later
- [ ] Once real usernames are added later, no code changes should be
      needed — only editing the config file values

## Stopping condition
Loop stops when every box above is checked AND the last two iterations
made no structural changes (only copy tweaks) — that's the signal it's
converged, not the iteration count.