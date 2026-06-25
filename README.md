# MediTake

<p align="center">
  <strong>An medication reminder platform designed to help people manage long-term treatments and improve medication adherence.</strong>
</p>

<p align="center">
  <a href="https://github.com/CuriousForLearningTech/Meditake/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License"></a>
  <a href="https://github.com/CuriousForLearningTech/Meditake/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
  <img src="https://img.shields.io/badge/Backend-FastAPI%20%7C%20Python-orange" alt="Backend">
  <img src="https://img.shields.io/badge/Web-Next.js%20%7C%20TypeScript-blue" alt="Web">
  <img src="https://img.shields.io/badge/Mobile-Flutter%20%7C%20Dart-cyan" alt="Mobile">
</p>

---

## Table of Contents

- [Motivation](#motivation)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Directory Structure](#project-directory-structure)
- [Local Setup](#local-setup)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)
- [Medical Disclaimer](#medical-disclaimer)

---

## Motivation

Millions of people living with chronic conditions such as diabetes, hypertension, thyroid disorders, and heart disease rely on daily medications. Missing doses can reduce treatment effectiveness and, in severe cases, lead to serious health complications.

**MediTake** aims to make medication management simple, reliable, and accessible through intelligent reminders and treatment tracking. It is built as a complete ecosystem containing a cross-platform mobile client, a web administration dashboard, and a secure backend service.

---

## Key Features

* 📱 **Cross-Platform Mobile App:** Designed in Flutter for a native look and feel on Android & iOS.
* 🌐 **Web Dashboard:** Managed with Next.js for treatment logging and analytics.
* ⚡ **FastAPI Backend:** Secure, fast backend API with automated Swagger/OpenAPI docs.
* ⏰ **Flexible Reminder Engine:** Set daily, weekly, or complex recurring interval schedules.
* 📊 **Adherence Reports:** Track dose compliance metrics over time and share reports with healthcare providers.
* 🔒 **Data Protection:** Built with strict authorization and row-level database security.

---

## Tech Stack

* **Mobile App:** [Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)
* **Web Frontend:** [Next.js](https://nextjs.org/) (React, TypeScript)
* **Backend API:** [FastAPI](https://fastapi.tiangolo.com/) (Python)
* **Database:** [PostgreSQL](https://www.postgresql.org/) (with SQLAlchemy ORM)

---

## Project Directory Structure

```text
├── backend/          # FastAPI services, schema, and API routes
├── mobile/           # Flutter mobile app code
├── web/              # Next.js web application code
├── docs/             # Technical specifications & documentation
├── .github/          # GitHub issues and pull request templates
├── LICENSE           # Apache 2.0 License file
├── NOTICE            # Copyright notice and attribution
├── CODE_OF_CONDUCT.md# Standards of community interaction
├── CONTRIBUTING.md   # Guidelines for local environment setup
└── SECURITY.md       # Secure vulnerability reporting policy
```

---

## Local Setup

Please see our [CONTRIBUTING.md](CONTRIBUTING.md) for step-by-step setup guides on setting up your local environment for:
* FastAPI backend API development
* Next.js web dashboard development
* Flutter mobile client development

---

## Contributing

We welcome contributions of all shapes and sizes! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before opening a pull request.

---

## Security

If you discover a security vulnerability, please do **not** open a public issue. Review our [SECURITY.md](SECURITY.md) for guidelines on reporting vulnerabilities privately.

---

## License

Licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## Medical Disclaimer

> [!CAUTION]
> **MediTake is intended to assist users with medication management and reminders.**
>
> It is **not** a medical device and does **not** replace professional medical advice, diagnosis, or treatment. Always consult qualified healthcare professionals regarding medical decisions.
