# Security Policy

## Supported version

Security fixes and documentation corrections are applied to the latest state of the `main` branch. The `v1.0.0` tag is a stable historical baseline.

## Reporting a vulnerability

Please do not publish credentials, Cloudflare tunnel tokens, private hostnames, authentication bypasses, personal data, or other sensitive deployment details in a public issue.

Use GitHub's private vulnerability reporting or security-advisory feature for this repository when available. Include:

- A clear description of the issue.
- The affected file, command, service, or configuration.
- Reproduction steps.
- Potential impact.
- A proposed mitigation, when known.

For ordinary hardening suggestions that do not disclose an exploitable secret, a public issue is appropriate.

## Secrets that must never be committed

- Cloudflare tunnel tokens and credentials.
- GitHub personal access tokens.
- SSH private keys.
- Open WebUI secrets, cookies, database exports, or account data.
- Domain-provider credentials.
- Private IP inventories or access-policy details.
- Docker-volume backups containing user data.

If a secret is exposed, revoke or rotate it immediately. Removing it from the latest commit is not sufficient because it may remain in Git history.

## Deployment responsibility

This project is a reproducible guide, not a managed security service. Operators remain responsible for access policies, account security, updates, backups, firewall configuration, and the data uploaded to Open WebUI.
