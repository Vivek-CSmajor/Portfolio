// GitHub's public contributions fragment (the same HTML GitHub renders inside
// a profile page) — no auth needed for a public profile. Each day renders a
// screen-reader tooltip like "3 contributions on January 5th." or "No
// contributions on January 6th."; summing those gives the total shown on the
// graph, without needing a token. Runs at build time only.
export async function getGithubContributionCount(username: string): Promise<number | null> {
  try {
    const res = await fetch(`https://github.com/users/${username}/contributions`);
    if (!res.ok) return null;

    const html = await res.text();
    let total = 0;
    let sawAny = false;
    for (const match of html.matchAll(/(\d+) contributions? on/g)) {
      total += parseInt(match[1], 10);
      sawAny = true;
    }
    return sawAny ? total : null;
  } catch {
    return null;
  }
}
