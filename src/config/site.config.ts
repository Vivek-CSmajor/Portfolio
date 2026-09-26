// Identity and contact destinations are centralized here. See SETUP.md.
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
