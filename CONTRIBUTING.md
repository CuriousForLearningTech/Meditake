# Contributing to MediTake

First of all, thank you for considering contributing to MediTake! 🎉

Whether you're fixing bugs, improving documentation, designing user interfaces, reviewing code, or proposing new features, your contribution helps make medication management more accessible, reliable, and safer for everyone.

---

## Code of Conduct & Safety First

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

> [!WARNING]
> **Important Safety Note:** Because MediTake is a healthcare-related application, all changes affecting medication logs, scheduling calculations, reminder intervals, timezone offsets, or data privacy will be scrutinized very carefully. Please ensure you write automated tests for these changes.

---

## Repository Structure

The MediTake repository is a monorepo structured as follows:

```text
├── backend/      # FastAPI REST API (Python)
├── web/          # Next.js web application (React, TypeScript)
├── mobile/       # Flutter application (Dart)
├── docs/         # Project documentation and specifications
└── LICENSE       # Apache 2.0 License
```

---

## Local Development Setup

To contribute to MediTake, you should set up the components you wish to work on. Below are the steps for setting up each module.

### 1. Backend Setup (FastAPI)

#### Prerequisites
* Python 3.11 or later
* PostgreSQL installed and running (or you can modify `database.py` to point to a local SQLite/PostgreSQL instance)

#### Setup Steps
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create a virtual environment:
   ```bash
   python -m venv .venv
   ```
3. Activate the virtual environment:
   * **Windows (PowerShell):**
     ```powershell
     .venv\Scripts\Activate.ps1
     ```
   * **Linux / macOS:**
     ```bash
     source .venv/bin/activate
     ```
4. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
5. Configure the Database connection in [database.py](backend/database.py). By default, it looks for a PostgreSQL database at `postgresql://postgres:Bright#1270@localhost/fastapi`.
6. Start the development server:
   ```bash
   uvicorn main:app --reload
   ```
   The API documentation will be available at [http://127:0.0.1:8000/docs](http://127.0.0.1:8000/docs).

---

### 2. Web Frontend Setup (Next.js)

#### Prerequisites
* Node.js v18.0.0 or later
* `pnpm` (preferred package manager)

#### Setup Steps
1. Navigate to the web directory:
   ```bash
   cd web
   ```
2. Install the node packages:
   ```bash
   pnpm install
   ```
3. Start the Next.js development server:
   ```bash
   pnpm dev
   ```
4. Open [http://localhost:3000](http://localhost:3000) in your web browser.

---

### 3. Mobile Client Setup (Flutter)

#### Prerequisites
* Flutter SDK (compatible with Dart `^3.12.2`)
* Android Studio / Xcode (for running emulators)

#### Setup Steps
1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```
2. Check your Flutter setup to make sure all tools are installed:
   ```bash
   flutter doctor
   ```
3. Fetch the Dart dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   * Ensure you have a device or emulator running:
     ```bash
     flutter devices
     ```
   * Run the app:
     ```bash
     flutter run
     ```

---

## Coding Standards & Linting

Please ensure your code conforms to the project's formatting and style guidelines before submitting a pull request.

### Python (Backend)
* Follow **PEP 8** style guidelines.
* We recommend formatting code using `black` or `ruff`:
  ```bash
  black .
  ```
* Run lints to check for errors:
  ```bash
  ruff check .
  ```

### JavaScript / TypeScript (Web)
* Use the project's ESLint rules:
  ```bash
  pnpm lint
  ```
* Format your code using Prettier:
  ```bash
  pnpm format
  ```

### Dart (Mobile)
* Follow official Dart style guidelines.
* Format code using `dart format`:
  ```bash
  dart format .
  ```
* Run analyzer to catch warnings:
  ```bash
  flutter analyze
  ```

---

## Pull Request Guidelines

1. **Fork & Branch:** Fork the repository and create a branch named `feature/your-feature-name` or `fix/your-fix-name`.
2. **Atomic Commits:** Keep commits focused and logically grouped. Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format for your messages:
   * `feat: add push notification handler`
   * `fix: prevent database session leak on route X`
   * `docs: update deployment guidelines`
3. **Write Tests:** Ensure new features have corresponding unit or widget tests. Run existing tests before making a PR:
   * Backend: `pytest` (if configured)
   * Mobile: `flutter test`
4. **Self-Review:** Look through your own diff before submitting to catch debug prints and commented-out code.
5. **Open a PR:** Open a PR against our `main` branch. Fill out the [Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md) completely.

---

## Questions and Discussions

If you have questions about setup, architecture, or a feature request, please open a GitHub Discussion rather than opening an issue, or chat with the maintainers. We are happy to help you get started!

Thank you for contributing to MediTake! 💙
