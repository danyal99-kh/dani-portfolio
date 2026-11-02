# Danyal Khodai — Portfolio

A bilingual personal portfolio for Danyal Khodai, a backend and Flutter
developer. Built with Flutter Web, `go_router`, and `shared_preferences`.

## Features

- Persian and English UI with RTL/LTR layout support.
- Light, dark, and system theme modes persisted in the browser.
- Dashboard, about, projects, project case studies, skills, resume, contact,
  and a small bug-squashing game.
- Responsive layout for mobile, tablet, and desktop.
- Local fonts and images; no backend or database required.
- Hash-based URLs so deep links work on GitHub Pages.

## Requirements

- Flutter 3.47.2 or newer.
- Dart 3.13.2 or newer.
- A modern browser for the web build.

## Local development

```bash
flutter pub get
flutter run -d chrome
```

## Checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Build for GitHub Pages

The repository is deployed under `/Dani_web/`:

```bash
flutter build web --release --base-href /Dani_web/
```

The output is written to `build/web/`. The GitHub Actions workflow in
`.github/workflows/deploy.yml` builds and deploys this directory automatically
when `main` is updated.

## Before publishing

The app currently ships with sample content. Replace these values before
publishing:

- `lib/data/content/contact_data.dart`: email, GitHub, Telegram, and LinkedIn.
- `lib/data/content/profile_data.dart`: name, tagline, bio, and availability.
- `lib/data/content/projects_data.dart`: project details and case studies.
- `lib/data/content/resume_data.dart`: education, experience, and languages.
- `assets/images/profile.jpg`: replace the placeholder profile image.
- `assets/resume/Danyal_Khodai_Resume.pdf`: replace the sample PDF.

The contact form opens the visitor's email client through `mailto:`. It does
not send data to a server. Placeholder links are detected and intentionally
blocked in the UI.

## Assets and licensing

All images and fonts are bundled locally. The images are placeholders and must
be replaced or verified before public distribution. The fonts are bundled from
their upstream releases; add the corresponding license files when publishing:

- Vazirmatn
- Space Grotesk
- JetBrains Mono

## Project structure

```text
lib/
  app/          app state, router, theme, localization, navigation
  core/         shared utilities and widgets
  data/         models and sample content
  features/     dashboard, about, projects, case study, skills,
                resume, contact, game, not-found
assets/
  fonts/
  images/
  resume/
web/
test/
```
