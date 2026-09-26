// Identity-dependent values live here. Swap the placeholders below for the
// real values (see SETUP.md) — no other file should need to change.
const GITHUB_USERNAME = "Vivek-CSmajor";
const LINKEDIN_USERNAME = "vivek-pandey-946297331";

export const siteConfig = {
  githubUsername: GITHUB_USERNAME,
  githubUrl: `https://github.com/${GITHUB_USERNAME}`,
  linkedinUrl: `https://linkedin.com/in/${LINKEDIN_USERNAME}`,
  email: "vivek.csmajor@gmail.com",
  resumeUrl: "/resume.pdf",
};

export function isPlaceholder(value: string) {
  return value.startsWith("YOUR_");
}
