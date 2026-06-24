# MediTake

**An medication reminder platform designed to help people manage long-term treatments and improve medication adherence.**

---

## Why MediTake?

Millions of people living with chronic conditions such as diabetes, hypertension, thyroid disorders, and heart disease rely on daily medications. Missing doses can reduce treatment effectiveness and, in severe cases, lead to serious health complications.

MediTake aims to make medication management simple, reliable, and accessible through intelligent reminders and treatment tracking.

---

## Features

### Current

* Prescription management
* Medication scheduling
* Daily reminders
* Dose history tracking
* Missed dose detection
* Support for long-term medications
* Fractional doses (½ tablet, ¼ tablet, etc.)
* Row-Level Security (RLS)
* Open-source and self-hostable

### Planned

* OCR prescription scanning
* Push notifications
* Refill reminders
* Medication adherence analytics
* Caregiver support
* Family accounts
* AI-powered insights
* Doctor sharing and exports
* Multi-timezone support
* Multi-language support

---


## Tech Stack

### Mobile

* Flutter

### Backend

* Python
* FastAPI

### Database

* PostgreSQL
* Supabase

### Authentication

* Supabase Auth

### Infrastructure

* Supabase Edge Functions
* Cron Jobs

---

## Repository Structure

```text
.
├── mobile/              # Flutter application
├── backend/             # Python services and APIs
├── database/            # Schema and migrations
├── docs/                # Documentation
├── assets/
├── .github/
├── LICENSE
└── README.md
```

---

## Roadmap

### MVP

* [x] Medicine catalog
* [x] Prescription management
* [x] Medication schedules
* [x] Scheduled doses
* [ ] Reminder engine
* [ ] Push notifications
* [ ] Flutter mobile application
* [ ] FastAPI backend
* [ ] Supabase integration

### Future

* [ ] OCR prescription import
* [ ] Refill tracking
* [ ] Adherence analytics
* [ ] Caregiver access
* [ ] Family profiles
* [ ] AI assistance
* [ ] Multi-timezone support
* [ ] Wearable integration

---

## Contributing

Contributions are welcome.

Whether you're fixing bugs, improving documentation, designing UI components, or adding new features, your help is appreciated.

Please read:

* CONTRIBUTING.md
* CODE_OF_CONDUCT.md

before opening a pull request.

---

## Security

If you discover a security vulnerability, please avoid opening a public issue. Instead, report it privately so it can be addressed responsibly.

---

## License

Licensed under the Apache License 2.0.

See the (LICENSE)[./LICENSE] file for details.

---

## Disclaimer

MediTake is intended to assist users with medication management and reminders.

It is **not** a medical device and does **not** replace professional medical advice, diagnosis, or treatment. Always consult qualified healthcare professionals regarding medical decisions.
