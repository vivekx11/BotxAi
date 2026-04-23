# BotX Build Guide

## ✅ Android Configuration Fixed!

The app is now properly configured for Android v2 embedding and ready to build.

---

## 🚀 Quick Build

### Debug Build (Fast)
```bash
flutter run
```

### Release APK (Production)
```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📋 Prerequisites

### Required
- ✅ Flutter SDK 3.22+
- ✅ Dart SDK 3.4+
- ✅ Android SDK (API 21-34)
- ✅ Android NDK 25.1.8937393 (auto-downloads)
- ✅ Java JDK 11+

### Check Installation
```bash
flutter doctor
```

All checks should pass (iOS can be skipped).

---

## 🔧 Build Steps

### 1. Clean Previous Builds
```bash
flutter clean
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Build APK
```bash
# Release APK (recommended)
flutter build apk --release

# Debug APK (for testing)
flutter build apk --debug

# Split APKs by ABI (smaller size)
flutter build apk --release --split-per-abi
```

### 4. Install on Device
```bash
# Install release APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Or use Flutter
flutter install
```

---

## 📦 Build Outputs

### Release APK
- **Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: ~50-80MB (with all dependencies)
- **Optimized**: Yes (minified, obfuscated)

### Split APKs (Recommended)
```bash
flutter build apk --release --split-per-abi
```

Generates 3 APKs:
- `app-armeabi-v7a-release.apk` (~30MB) - 32-bit ARM
- `app-arm64-v8a-release.apk` (~35MB) - 64-bit ARM (most devices)
- `app-x86_64-release.apk` (~40MB) - x86 devices

**Install the appropriate one for your device.**

---

## 🎯 Build Configurations

### Current Settings

**`android/app/build.gradle`**:
```gradle
android {
    compileSdk 34
    
    defaultConfig {
        applicationId "com.example.botx"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "2.0.0"
    }
}
```

### Change App ID
Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.botx"  // Change this
}
```

### Change Version
```gradle
defaultConfig {
    versionCode 2           // Increment for updates
    versionName "2.1.0"     // User-visible version
}
```

---

## 🔐 Code Signing (For Play Store)

### 1. Create Keystore
```bash
keytool -genkey -v -keystore ~/botx-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias botx
```

### 2. Create `android/key.properties`
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=botx
storeFile=C:/path/to/botx-release-key.jks
```

### 3. Update `android/app/build.gradle`
Add before `android` block:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 4. Build Signed APK
```bash
flutter build apk --release
```

---

## 📱 App Bundle (For Play Store)

### Build AAB
```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### Why AAB?
- ✅ Smaller downloads (Google optimizes per device)
- ✅ Required for Play Store
- ✅ Dynamic delivery support

---

## 🐛 Troubleshooting

### Build Fails: "Android v1 embedding"
✅ **Fixed!** The app now uses v2 embedding.

### Build Fails: "NDK not found"
The build will auto-download NDK. Wait for it to complete (5-10 minutes first time).

### Build Fails: "Dependency conflict"
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Build Takes Too Long
First build downloads NDK (~1GB). Subsequent builds are faster.

### Out of Memory
Increase Gradle memory in `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4G
```

### Permission Denied Errors
Close Android Studio and any Gradle daemons:
```bash
./gradlew --stop
```

---

## ⚡ Build Optimization

### Reduce APK Size

1. **Enable Proguard** (already enabled):
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}
```

2. **Split by ABI**:
```bash
flutter build apk --release --split-per-abi
```

3. **Remove unused resources**:
```gradle
android {
    buildTypes {
        release {
            shrinkResources true
        }
    }
}
```

### Speed Up Builds

1. **Enable Gradle daemon** (already enabled)

2. **Increase memory**:
```properties
org.gradle.jvmargs=-Xmx4G
```

3. **Use build cache**:
```gradle
android {
    buildCache {
        enabled = true
    }
}
```

---

## 📊 Build Variants

### Debug
```bash
flutter build apk --debug
```
- Larger size
- Not optimized
- Includes debug symbols
- Fast build

### Profile
```bash
flutter build apk --profile
```
- Medium size
- Some optimization
- Performance profiling enabled

### Release
```bash
flutter build apk --release
```
- Smallest size
- Fully optimized
- No debug info
- Production ready

---

## 🚀 CI/CD Integration

### GitHub Actions Example

```yaml
name: Build APK

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '11'
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.0'
    
    - run: flutter pub get
    - run: flutter build apk --release
    
    - uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📝 Build Checklist

Before building for production:

- [ ] Update version in `pubspec.yaml`
- [ ] Update versionCode in `build.gradle`
- [ ] Test on multiple devices
- [ ] Run `flutter analyze` (0 errors)
- [ ] Run `flutter test` (all pass)
- [ ] Create keystore for signing
- [ ] Configure `key.properties`
- [ ] Build signed APK/AAB
- [ ] Test signed build
- [ ] Prepare Play Store assets

---

## 🎯 Quick Commands

```bash
# Clean build
flutter clean && flutter pub get && flutter build apk --release

# Build and install
flutter build apk --release && adb install build/app/outputs/flutter-apk/app-release.apk

# Build split APKs
flutter build apk --release --split-per-abi

# Build app bundle
flutter build appbundle --release

# Check build size
ls -lh build/app/outputs/flutter-apk/

# Run on device
flutter run --release
```

---

## 📈 Build Times

| Build Type | First Build | Subsequent |
|------------|-------------|------------|
| Debug | 5-10 min | 1-2 min |
| Release | 10-15 min | 2-3 min |
| App Bundle | 10-15 min | 2-3 min |

*First build includes NDK download*

---

## 🔗 Resources

- **Flutter Build Docs**: https://docs.flutter.dev/deployment/android
- **Android Signing**: https://developer.android.com/studio/publish/app-signing
- **Play Store Guide**: https://support.google.com/googleplay/android-developer/

---

## ✅ Build Status

- ✅ Android v2 embedding configured
- ✅ Dependencies resolved
- ✅ Gradle configured
- ✅ Build scripts ready
- ✅ Ready for production

---

**Build the app and start using BotX!** 🚀

```bash
flutter build apk --release
```

**APK Location**: `build/app/outputs/flutter-apk/app-release.apk`

**Install**: `adb install build/app/outputs/flutter-apk/app-release.apk`

---

**Version**: 2.0.0

**Last Updated**: 2026-04-22

**Status**: ✅ Ready to Build
