# BotX Setup Checklist

Use this checklist to ensure your BotX app is properly configured and ready to run.

## ✅ Pre-Installation

- [ ] Flutter SDK installed (3.22+)
- [ ] Dart SDK installed (3.4+)
- [ ] Android Studio or VS Code installed
- [ ] Android device or emulator available
- [ ] Git installed (for cloning)

### Verify Flutter Installation
```bash
flutter doctor
```
All checks should pass (iOS can be skipped for Android-only).

## ✅ Project Setup

- [ ] Project cloned/downloaded
- [ ] Navigated to project directory
- [ ] Dependencies installed: `flutter pub get`
- [ ] Code generated: `flutter pub run build_runner build --delete-conflicting-outputs`

### Check for Errors
```bash
flutter analyze
```
Should show 0 issues (warnings are okay).

## ✅ API Keys Configuration

### Required: Gemini AI API Key
- [ ] Visited [Google AI Studio](https://makersuite.google.com/app/apikey)
- [ ] Created/copied API key
- [ ] Opened `lib/features/chat/providers/ai_provider.dart`
- [ ] Replaced `YOUR_GEMINI_API_KEY` on line 9
- [ ] Saved file

**Verification**: Search for "YOUR_GEMINI_API_KEY" in project - should find 0 results.

### Optional: Weather API Key
- [ ] Visited [OpenWeatherMap](https://openweathermap.org/api)
- [ ] Signed up and got API key
- [ ] Opened `lib/core/network/weather_api.dart`
- [ ] Replaced `YOUR_OPENWEATHERMAP_API_KEY` on line 6
- [ ] Saved file

## ✅ Assets Setup

### Fonts (Required)
- [ ] Created `assets/fonts/` directory
- [ ] Downloaded Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins)
- [ ] Added `Poppins-Regular.ttf` to `assets/fonts/`
- [ ] Added `Poppins-Medium.ttf` to `assets/fonts/`
- [ ] Added `Poppins-SemiBold.ttf` to `assets/fonts/`
- [ ] Added `Poppins-Bold.ttf` to `assets/fonts/`

**Verification**: Check that all 4 font files exist in `assets/fonts/`.

### Directories (Required)
- [ ] Created `assets/lottie/` directory
- [ ] Created `assets/images/` directory
- [ ] Created `assets/icons/` directory

```bash
mkdir -p assets/lottie assets/images assets/icons assets/fonts
```

### Lottie Animations (Optional)
- [ ] Downloaded animations from [LottieFiles](https://lottiefiles.com/)
- [ ] Added `ai-robot.json` to `assets/lottie/` (for splash)
- [ ] Added `loading.json` to `assets/lottie/` (for loading states)
- [ ] Added `voice-wave.json` to `assets/lottie/` (for voice screen)

**Note**: App works without Lottie files, but animations enhance UX.

## ✅ Android Configuration

### Device Setup
- [ ] Android device connected OR emulator running
- [ ] USB debugging enabled (for physical device)
- [ ] Device appears in `flutter devices`

### Verify Device
```bash
flutter devices
```
Should show at least one Android device.

### Build Configuration
- [ ] Checked `android/app/build.gradle` has correct settings:
  - [ ] `minSdkVersion 21`
  - [ ] `targetSdkVersion 34`
  - [ ] `compileSdkVersion 34`

## ✅ Permissions

The app will request these at runtime:
- [ ] Understood: Microphone (for voice commands)
- [ ] Understood: Notifications (for reminders)
- [ ] Understood: Camera (optional, for profile picture)
- [ ] Understood: Contacts (optional, for quick access)

**Note**: Grant permissions when prompted on first launch.

## ✅ First Run

### Clean Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run App
```bash
flutter run
```

### Expected Behavior
- [ ] App launches without errors
- [ ] Splash screen appears for 3 seconds
- [ ] Welcome screen shows with 3 slides
- [ ] Can swipe through onboarding
- [ ] "Get Started" button works
- [ ] Permission dialogs appear
- [ ] Chat screen loads successfully

## ✅ Feature Testing

### Chat Feature
- [ ] Can type message in input field
- [ ] Send button works
- [ ] AI responds to messages
- [ ] Messages appear in chat
- [ ] Suggestion chips appear
- [ ] Can long-press message for options
- [ ] Drawer opens from menu icon

### Navigation
- [ ] Can navigate to Voice screen
- [ ] Can navigate to Tools dashboard
- [ ] Can navigate to Settings
- [ ] Can navigate to Profile
- [ ] Can navigate to About
- [ ] Back button works on all screens

### Settings
- [ ] Theme switcher works (Light/Dark/System)
- [ ] Voice speed slider works
- [ ] Voice pitch slider works
- [ ] Offline mode toggle works
- [ ] Notifications toggle works
- [ ] Clear history shows confirmation

### Tools
- [ ] Tools dashboard shows 6 tool cards
- [ ] Calculator opens and works
- [ ] Notes screen opens
- [ ] Weather screen opens
- [ ] Translator screen opens

### AI Commands
Try these in chat:
- [ ] "Hello" → Gets greeting
- [ ] "What time is it?" → Shows current time
- [ ] "What's the date?" → Shows current date
- [ ] "What's my battery level?" → Shows battery status
- [ ] "Open Instagram" → Confirms app launch
- [ ] "Calculate 25 * 4" → Responds about calculator

## ✅ Build Testing

### Debug Build
```bash
flutter build apk --debug
```
- [ ] Build completes without errors
- [ ] APK created in `build/app/outputs/flutter-apk/`

### Release Build
```bash
flutter build apk --release
```
- [ ] Build completes without errors
- [ ] APK size is reasonable (<50MB)
- [ ] Can install and run release APK

## ✅ Code Quality

### Analysis
```bash
flutter analyze
```
- [ ] 0 errors
- [ ] Warnings are acceptable

### Formatting
```bash
flutter format lib/
```
- [ ] Code is properly formatted

## 🐛 Troubleshooting

If you encounter issues, check these:

### "API key not valid" Error
- [ ] Verified API key is correct
- [ ] Checked for extra spaces in API key
- [ ] Confirmed API key is active in Google AI Studio
- [ ] Device has internet connection

### "Font not found" Error
- [ ] Verified all 4 font files exist in `assets/fonts/`
- [ ] Checked file names match exactly (case-sensitive)
- [ ] Ran `flutter clean` and `flutter pub get`
- [ ] Restarted IDE

### Build Errors
- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Ran build_runner again
- [ ] Checked Flutter version: `flutter --version`
- [ ] Updated Flutter: `flutter upgrade`

### App Crashes
- [ ] Checked logs: `flutter logs`
- [ ] Verified API keys are set
- [ ] Verified fonts are in place
- [ ] Checked device is API 21+
- [ ] Tried on different device/emulator

### Permission Issues
- [ ] Went to device Settings > Apps > BotX > Permissions
- [ ] Manually enabled required permissions
- [ ] Restarted app

## ✅ Optional Enhancements

### Custom App Icon
- [ ] Installed `flutter_launcher_icons` package
- [ ] Created app icon (1024x1024)
- [ ] Configured in `pubspec.yaml`
- [ ] Generated icons: `flutter pub run flutter_launcher_icons`

### Custom Splash Screen
- [ ] Installed `flutter_native_splash` package
- [ ] Created splash image
- [ ] Configured in `pubspec.yaml`
- [ ] Generated splash: `flutter pub run flutter_native_splash:create`

### Code Signing (for Release)
- [ ] Created keystore file
- [ ] Created `key.properties` file
- [ ] Updated `build.gradle` for signing
- [ ] Tested signed build

## ✅ Documentation Review

- [ ] Read `README.md` for full documentation
- [ ] Read `QUICKSTART.md` for quick setup
- [ ] Read `PROJECT_SUMMARY.md` for project overview
- [ ] Bookmarked Flutter docs: https://docs.flutter.dev

## ✅ Ready for Development

Once all checks pass:
- [ ] App runs without errors
- [ ] All core features work
- [ ] API keys configured
- [ ] Assets in place
- [ ] Ready to customize and extend

## 🎉 Success Criteria

Your BotX app is ready when:
1. ✅ App launches successfully
2. ✅ Can complete onboarding
3. ✅ Can send and receive chat messages
4. ✅ AI responds correctly
5. ✅ Navigation works between screens
6. ✅ Settings persist after app restart
7. ✅ No critical errors in logs

## 📝 Notes

- Keep your API keys secure (don't commit to Git)
- Test on multiple devices if possible
- Check logs regularly during development
- Update dependencies periodically
- Back up your work frequently

## 🆘 Still Having Issues?

1. Check the troubleshooting section in `README.md`
2. Review Flutter documentation
3. Check package documentation on pub.dev
4. Search for error messages online
5. Open an issue on GitHub with:
   - Error message
   - Steps to reproduce
   - Flutter doctor output
   - Device information

---

**Checklist Version**: 1.0.0

**Last Updated**: 2026-04-22

Good luck with your BotX app! 🚀
