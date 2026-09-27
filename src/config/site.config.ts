// Identity-dependent values live here. Swap the placeholders below for the
// real values (see SETUP.md) — no other file should need to change.
const GITHUB_USERNAME = "Vivek-CSmajor";
const LINKEDIN_USERNAME = "vivek-pandey-946297331";
const LEETCODE_USERNAME = "vivek-CSmajor";
const INSTAGRAM_USERNAME = "vivekkk_199";

export const siteConfig = {
  githubUsername: GITHUB_USERNAME,
  githubUrl: `https://github.com/${GITHUB_USERNAME}`,
  linkedinUrl: `https://linkedin.com/in/${LINKEDIN_USERNAME}`,
  leetcodeUrl: `https://leetcode.com/${LEETCODE_USERNAME}`,
  instagramUrl: `https://instagram.com/${INSTAGRAM_USERNAME}`,
  email: "vivek.csmajor@gmail.com",
  phone: "+91 96960 06439",
  resumeUrl: "/resume.pdf",
};

export function isPlaceholder(value: string) {
  return value.startsWith("YOUR_");
}
