# VijayAI Connect – Ads Ready (Test IDs)

This starter Flutter project has Google Mobile Ads integrated using **Google Test IDs**.
Replace them with your own AdMob IDs (from your AdMob account) to start real earnings.

## How to Use
1. Download & extract this ZIP.
2. Push all files to your GitHub repository (main branch).
3. Go to **Actions** tab → run **Flutter Build APK** (it also runs automatically on push).
4. After success, download the APK from **Actions → Run → Artifacts → release-apk**.

## Where to put your AdMob IDs
- Edit `config/app_config.json` and replace all test IDs with your real IDs.
- Make sure you have added your app in AdMob and created Ad Units first.

## Local Run (optional)
```bash
flutter pub get
flutter run
```

## Notes
- Workflow uses `flutter create .` to generate `android/ios` if missing, so you don't need them in git.
- Java 17 is configured for Gradle/Android build.
