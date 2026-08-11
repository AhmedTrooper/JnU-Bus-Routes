# 🔧 Developer Guide — JnU Bus Routes

This document covers everything a developer needs to clone, build, test, sign, and release the app.

---

## 📋 Prerequisites

| Requirement | Version |
|---|---|
| **Flutter SDK** | 3.24.x or later (stable channel) |
| **Dart SDK** | 3.12.2+ (bundled with Flutter) |
| **Java / JDK** | 17 (required by Android Gradle Plugin) |
| **Android SDK** | API 21+ (minSdk) |
| **Git** | 2.x+ |

Verify your setup:
```bash
flutter doctor -v
```
All checkmarks should be green for the Android toolchain. iOS/macOS/Web/Linux are optional.

---

## 🏃 Running Locally

```bash
# 1. Clone the repository
git clone https://github.com/AhmedTrooper/JnU-Bus-Routes.git
cd JnU-Bus-Routes

# 2. Install dependencies
flutter pub get

# 3. Connect a device or start an emulator
flutter devices

# 4. Run in debug mode
flutter run

# 5. Run in release mode (local debug signing)
flutter run --release
```

---

## 🧪 Testing & Linting

Always run these before committing:

```bash
# Static analysis (only fails on actual errors, not infos/warnings)
flutter analyze --no-fatal-infos --no-fatal-warnings

# Run all unit & widget tests
flutter test

# Run both in one shot (this is what CI does)
flutter analyze --no-fatal-infos --no-fatal-warnings && flutter test
```

The test suite covers responsive layout rendering across screen sizes from 100×100 to 1200×800.

---

## 📦 Building a Release APK / AAB

### Option A: Local Build (Debug-Signed)

If you just need a quick APK for testing without Play Store signing:

```bash
# APK (direct install)
flutter build apk --release

# AAB (Play Store upload)
flutter build appbundle --release
```

Output locations:
- APK → `build/app/outputs/flutter-apk/app-release.apk`
- AAB → `build/app/outputs/bundle/release/app-release.aab`

> ⚠️ Without a keystore configured, these will be signed with debug keys. They work for sideloading but **cannot** be uploaded to the Google Play Store.

---

### Option B: Local Build (Production-Signed)

To sign with your real upload keystore locally:

#### Step 1 — Generate a Keystore (one-time)

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

⚡ **Save this file somewhere safe. If you lose it, you cannot push updates to the same Play Store listing.**

#### Step 2 — Place the Keystore

Copy the `.jks` file into the Android app directory:

```bash
cp /path/to/upload-keystore.jks android/app/upload-keystore.jks
```

#### Step 3 — Create `key.properties`

Create a file at `android/app/key.properties` with your credentials:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

> 🛡️ **Never commit this file or the `.jks` file to Git.** Both are already in `.gitignore`.

#### Step 4 — Build

```bash
flutter build apk --release
flutter build appbundle --release
```

The Gradle build script (`android/app/build.gradle.kts`) automatically detects `key.properties` and uses it for release signing. If the file doesn't exist, it falls back to debug signing.

---

## 🤖 CI/CD — GitHub Actions

The repository includes an automated build pipeline at `.github/workflows/build_release.yml`.

### Trigger

The workflow runs **only on push to the `release` branch**. It does not run on `main`, `dev`, or pull requests.

### Pipeline Steps

```
Checkout → Setup Java 17 → Setup Flutter → Install Deps → Analyze & Test → Decode Keystore → Build APK → Build AAB → Upload Artifacts → Cleanup
```

### Required GitHub Secrets

Go to **GitHub → Your Repo → Settings → Secrets and variables → Actions → New repository secret** and add:

| Secret Name | What It Is | How to Get It |
|---|---|---|
| `KEYSTORE_BASE64` | Your `.jks` keystore file encoded as a Base64 string | Run: `base64 -w 0 upload-keystore.jks` and copy the output |
| `KEYSTORE_PASSWORD` | The password you set when generating the keystore | You chose this during `keytool -genkey` |
| `KEY_PASSWORD` | The password for the specific key alias | Often the same as `KEYSTORE_PASSWORD` |
| `KEY_ALIAS` | The alias name of your signing key | Usually `upload` (or whatever you passed to `-alias`) |

### How to Encode Your Keystore

```bash
# Linux
base64 -w 0 upload-keystore.jks > keystore_base64.txt

# macOS
base64 upload-keystore.jks > keystore_base64.txt
```

Open `keystore_base64.txt`, copy the **entire** content, and paste it as the value of `KEYSTORE_BASE64` in GitHub Secrets.

### Triggering a Release Build

```bash
# From your dev branch, merge into release and push
git checkout release
git merge dev
git push origin release
```

Then go to the **Actions** tab in GitHub. You'll see the build running. When it completes, download the signed APK and AAB from the **Artifacts** section at the bottom of the workflow summary.

---

## 📁 Project Structure

```
JnU-Bus-Routes/
├── .github/workflows/             # CI/CD pipeline
│   └── build_release.yml          # Production build workflow
├── android/                       # Android native config
│   └── app/
│       ├── build.gradle.kts       # Gradle build with signing config
│       └── src/main/
│           └── AndroidManifest.xml
├── assets/
│   ├── database/jnu.db            # Bundled SQLite database
│   └── images/                    # App images
├── lib/
│   ├── core/                      # Shared: themes, DB, router, services
│   ├── features/                  # Feature modules (bus_routes, tracking_map, search, settings)
│   └── main.dart                  # App entry point
├── test/
│   └── widget_test.dart           # Responsive layout tests
├── pubspec.yaml                   # Dependencies & assets
├── README.md                      # Project overview (recruiter-facing)
└── DEVELOPER.md                   # This file
```

---

## 🗄️ Database

The app ships with a pre-populated SQLite database at `assets/database/jnu.db`. This database contains:

- **Buses** — name, type (student/teacher/staff), up/down schedule times, terminal stoppage, Google Maps direction URLs
- **Places** — all stoppages with metadata
- **Relations** — bus-to-stoppage mappings with sequence order for each direction (up/down)

On first launch, the database is copied from assets to the device's local storage. Updates to the database require a new app version with an updated `jnu.db` asset.

---

## 🎨 Design System

The app uses a custom Shadcn-inspired component library located in `lib/core/widgets/shadcn_components.dart`:

- `ShadcnCard` — bordered card with hover/tap effects
- `ShadcnBadge` — colored tag badges
- `ShadcnInputBar` — styled search input

Colors are defined in `lib/core/constants/app_colors.dart` with full dark/light mode support. The theme is configured in `lib/core/constants/app_theme.dart`.

---

## 🔒 Security Notes

- **Never commit** `upload-keystore.jks` or `key.properties` to version control
- The `.gitignore` should already exclude these files — verify before pushing
- In CI, the keystore is decoded from a GitHub Secret and deleted after the build
- GitHub Actions runners are ephemeral — secrets are not persisted after the job ends

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make changes and ensure `flutter analyze && flutter test` passes
4. Commit with clear messages: `git commit -m "feat(scope): description"`
5. Push and open a Pull Request against `dev`

Follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.
