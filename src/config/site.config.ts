// Identity-dependent values live here. Swap the placeholders below for the
// real values (see SETUP.md) — no other file should need to change.
const GITHUB_USERNAME = "YOUR_GITHUB_USERNAME";
const LEETCODE_USERNAME = "YOUR_LEETCODE_USERNAME";
const LINKEDIN_USERNAME = "YOUR_LINKEDIN_USERNAME";

export const siteConfig = {
  githubUsername: GITHUB_USERNAME,
  leetcodeUsername: LEETCODE_USERNAME,
  githubUrl: `https://github.com/${GITHUB_USERNAME}`,
  linkedinUrl: `https://linkedin.com/in/${LINKEDIN_USERNAME}`,
  email: "vivek.csmajor@gmail.com",
  resumeUrl: "/resume.pdf",
};

export function isPlaceholder(value: string) {
  return value.startsWith("YOUR_");
}
