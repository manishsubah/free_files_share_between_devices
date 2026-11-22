# Free File Share

Send files directly between your phone and your computer — over Wi-Fi, a USB cable or Bluetooth — with no cloud, no account and no compression.

First release: **Windows** desktop app + **Android** mobile app.

See [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md) for the idea, architecture and roadmap.

## Requirements

- Flutter **3.47.1** (Dart 3.13.1). Check with `flutter --version`.
- Windows: Visual Studio 2022 with the "Desktop development with C++" workload.
- Android: Android Studio / Android SDK, a device or emulator running Android 8.0+.

## Getting started

```sh
flutter pub get          # resolves the whole workspace
dart run melos run gen   # code generation (freezed, injectable, auto_route)
```

Run the apps:

```sh
cd apps/desktop && flutter run -d windows
cd apps/mobile  && flutter run -d <android-device-id>
```

## Everyday commands

| Command | What it does |
|---|---|
| `dart run melos run gen` | Regenerate code after changing annotated classes |
| `dart run melos run verify` | Format check + analyze + all tests (same as CI) |
| `dart run melos analyze` | Analyze every package |
| `dart run melos test` | Run every package's tests |
| `dart run melos format` | Format all code |

Tip: `dart pub global activate melos` lets you type `melos ...` instead of `dart run melos ...`.

## Repository layout

```
apps/
  desktop/              Windows app shell
  mobile/               Android app shell
packages/
  core/                 foundation, design_system, di, storage, platform
  connectivity/         transport, transport_lan, secure_channel, protocol, session
  features/             onboarding, discovery, pairing, transfer, history, settings
  navigation/           router and root app widget
docs/                   project plan and design notes
```

Each feature package follows Clean Architecture: `domain` → `data` → `presentation`.
