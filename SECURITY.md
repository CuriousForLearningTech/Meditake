# Security Policy

We take the security of MediTake seriously. If you believe you have found a security vulnerability, we appreciate your help in reporting it to us responsibly.

---

## Supported Versions

Security fixes are actively applied to the following versions of MediTake:

| Component | Branch / Version | Supported | Notes |
| :--- | :--- | :--- | :--- |
| **Backend API** | `main` | ✅ Yes | Active development and deployments |
| **Mobile App** | `main` | ✅ Yes | Play Store and App Store releases |
| **Web Frontend** | `main` | ✅ Yes | Web client deployments |
| **Older Releases** | `< v1.0.0` | ❌ No | Please upgrade to the latest version |

---

## Reporting a Vulnerability

> [!IMPORTANT]
> **Please do not open public GitHub issues for security vulnerabilities.** Publicly disclosing a vulnerability before a fix is ready makes systems vulnerable and compromises user safety.

Instead, please report security issues privately:
1. **Email:** Send a detailed email to [security@meditake.org](mailto:security@meditake.org). If possible, encrypt your message using our PGP key (details provided upon request).
2. **GitHub Security Advisory:** Alternatively, if you are a repository member, you can draft a private security advisory through the GitHub UI under the "Security" tab.

### What to Include in a Report
To help us triage and fix the vulnerability quickly, please include as much of the following as possible:
* **Description:** A detailed description of the vulnerability and its potential impact.
* **Component:** The affected component(s) (e.g. backend, mobile, database, web client).
* **Steps to Reproduce:** A clear step-by-step guide to reproduce the issue, or a minimal Proof of Concept (PoC) script/payload.
* **Environment:** OS, library versions, database versions, or device type.
* **Mitigation:** Any temporary workaround or suggestions for a permanent fix.

---

## Our Security Principles

MediTake is a health management platform, which makes security and privacy core values of our system:

### 1. Privacy by Design & Default
We only store medication and scheduling data necessary to trigger reminders and track adherence. PII and medical lists must never be leaked in app logs, telemetry, or third-party tracking.

### 2. Defense in Depth
Controls must be present at multiple layers:
* Strong JWT token authentication for API routes.
* Database-level Row-Level Security (RLS) rules.
* Strict input validation on backend controllers (using Pydantic models).
* HTTPS/TLS enforced for all client-server communications.

### 3. Least Privilege
Services and client applications must only have the minimum database permissions required to function. Secrets, service accounts, and API credentials must be secured using appropriate access control lists (ACLs).

---

## Secrets Management

> [!CAUTION]
> **Never commit secrets to the codebase.** This includes API keys, database passwords, OAuth tokens, private certificates, or `.env` files.

* If you are working locally, use environment variables or a `.env` file that is excluded in `.gitignore`.
* If a secret is accidentally committed, notify the maintainers immediately so it can be revoked, rotated, and the Git history cleaned.

---

## Code Review & Security Auditing

All pull requests that affect authentication, authorization, cryptography, database access, or dependency updates undergo a mandatory security review by project maintainers before merging.

### Dependencies
We run automated vulnerability scanning on dependencies (e.g., GitHub Dependabot). Contributors are encouraged to keep dependencies up-to-date and resolve any alerts from `npm audit`, `pip audit`, or `flutter pub outdated` before submitting PRs.

---

## Response and Disclosure Timeline

1. **Acknowledgment:** We will acknowledge receipt of your vulnerability report within **48 hours**.
2. **Triage & Investigation:** We will investigate the issue and keep you updated on our progress.
3. **Fix:** We aim to resolve critical vulnerabilities within **15 days** and high/medium vulnerabilities within **30 days** of receipt.
4. **Disclosure:** Once a patch is released, we will coordinate public disclosure (and credit you for the discovery, if you wish) through release notes or security advisories.

Thank you for helping keep MediTake and its users safe!
