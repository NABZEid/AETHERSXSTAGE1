# NEXORA: Battle Arena — Tahap 1 (Prototipe)

## Setup
    flutter create --org com.nexora --project-name nexora --platforms android nexora_app
    # salin folder lib/ dan pubspec.yaml dari zip ini ke nexora_app/ (timpa)
    rm nexora_app/test/widget_test.dart
    cd nexora_app && flutter pub get && flutter run

Android: set `minSdkVersion 26` (Android 8.0) di android/app/build.gradle(.kts) bila perlu.

## Uji
- Joystick kiri bawah menggerakkan ZHAVEN (biru); kamera mengikuti.
- Diam = auto-attack; tombol ATK = serang manual.
- Wave 3 minion/tim tiap 15 detik di mid lane; turret biru & merah menembak minion dulu.
- BOT KAEL (merah) mengejar hero Anda, mundur ke base saat HP < 30%, respawn 5 detik.
