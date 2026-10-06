# Security hardening checklist

- [ ] Controller built-in node set to 0 executors
- [ ] Controller served over HTTPS (reverse proxy)
- [ ] Agent to Controller access control left enabled (default)
- [ ] Each agent runs as a dedicated low-privilege user (no sudo)
- [ ] Agent secrets passed via file, not command-line arguments
- [ ] Secrets rotated if exposed
- [ ] Builds run in containers or on ephemeral agents
- [ ] Trusted and untrusted jobs (e.g. fork PRs) use separate agents
- [ ] Credentials scoped to folders, not global
- [ ] Firewall: agents may only reach the controller and required services
