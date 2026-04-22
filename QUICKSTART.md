# BotX Quick Start Guide

Get BotX up and running in 5 minutes!

## ⚡ Quick Setup

### 1. Install Flutter (if not already installed)
```bash
# Check if Flutter is installed
flutter --version

# If not installed, visit: https://docs.flutter.dev/get-started/install
```

### 2. Clone and Setup
```bash
# Navigate to the project directory
cd botx

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Add API Keys

#### Required: Gemini AI API Key
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Click "Create API Key"
3. Copy your key
4. Open `lib/features/chat/providers/ai_provider.dart`
5. Replace line 9:
```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY';
// Change to:
static const String _apiKey = 'your-actual-api-key-here';
```

#### Optional: Weather API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up and get free API key
3. Open `lib/core/network/weather_api.dart`
4. Replace line 6:
```dart
static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
// Change to:
static const String _apiKey = 'your-actual-api-key-here';
```

### 4. Add Fonts (Required)

Download Poppins font:
1. Visit [Google Fonts - Poppins](https://fonts.google.com/specimen/Poppins)
2. Download the font family
3. Extract and copy these files to `assets/fonts/`:
   - `Poppins-Regular.ttf`
   - `Poppins-Medium.ttf`
   - `Poppins-SemiBold.ttf`
   - `Poppins-Bold.ttf`

Or use this quick command (if you have wget):
```bash
mkdir -p assets/fonts
cd assets/fonts
# Download from a CDN or Google Fonts
```

### 5. Create Asset Directories
```bash
mkdir -p assets/lottie
mkdir -p assets/images
mkdir -p assets/icons
```

### 6. Run the App
```bash
# Connect your Android device or start emulator
flutter devices

# Run the app
flutter run
```

## 🎯 First Launch

1. **Splash Screen** - Shows for 3 seconds
2. **Welcome Screen** - Swipe through 3 onboarding slides
3. **Permissions** - Grant microphone and notification permissions
4. **Chat Screen** - Start chatting with BotX!

## 💬 Try These Commands

Once the app is running, try:

### Chat Commands
- "Hello" - Get a greeting
- "What time is it?" - Get current time
- "What's the weather?" - Check weather
- "Open Instagram" - Launch Instagram app
- "Calculate 25 * 4" - Do math
- "What's my battery level?" - Check battery

### Voice Commands
1. Tap the mic icon in chat input
2. Or navigate to Voice screen from drawer
3. Tap the mic button
4. Speak any command above

## 🛠️ Troubleshooting

### "API key not valid"
- Make sure you replaced `YOUR_GEMINI_API_KEY` with your actual key
- Check that the key is active in Google AI Studio
- Ensure you have internet connection

### "Font not found" error
- Verify fonts are in `assets/fonts/` directory
- Check `pubspec.yaml` has correct font paths
- Run `flutter clean` then `flutter pub get`

### "Permission denied" for microphone
- Go to device Settings > Apps > BotX > Permissions
- Enable Microphone permission
- Restart the app

### Build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### App crashes on launch
- Check that all API keys are set
- Ensure fonts are in place
- Check Android device is API 21+
- View logs: `flutter logs`

## 📱 Testing on Device

### Enable Developer Mode (Android)
1. Go to Settings > About Phone
2. Tap "Build Number" 7 times
3. Go back to Settings > Developer Options
4. Enable "USB Debugging"

### Connect Device
```bash
# Check device is connected
adb devices

# Run app
flutter run
```

## 🚀 Build Release APK

```bash
# Build release APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📚 Next Steps

1. **Customize AI Personality**
   - Edit system prompt in `lib/features/chat/providers/ai_provider.dart`

2. **Add More Intents**
   - Modify `_handleIntent()` method in AI provider

3. **Customize Theme**
   - Edit colors in `lib/core/constants/app_colors.dart`
   - Modify theme in `lib/core/theme/app_theme.dart`

4. **Add Lottie Animations** (Optional)
   - Download from [LottieFiles](https://lottiefiles.com/)
   - Add to `assets/lottie/`
   - Update splash and voice screens

## 🎨 Customization Tips

### Change App Name
1. Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application android:label="YourAppName">
```

2. Edit `lib/core/constants/app_strings.dart`:
```dart
static const appName = 'YourAppName';
```

### Change App Icon
1. Add your icon to `android/app/src/main/res/mipmap-*/`
2. Or use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

### Change Colors
Edit `lib/core/constants/app_colors.dart`:
```dart
static const darkAccent1 = Color(0xFFYOURCOLOR);
static const darkAccent2 = Color(0xFFYOURCOLOR);
```

## ❓ Common Questions

**Q: Do I need both API keys?**
A: Only Gemini AI key is required. Weather key is optional.

**Q: Can I use without internet?**
A: Yes! Offline mode provides basic functionality.

**Q: Does it work on iOS?**
A: This version is Android-only. iOS requires additional setup.

**Q: How do I add more apps to control?**
A: Edit `_appPackages` map in `lib/core/utils/intent_launcher.dart`

**Q: Can I change the voice?**
A: Yes! Adjust pitch and speed in Settings screen.

## 🆘 Need Help?

- Check the main [README.md](README.md) for detailed documentation
- Review Flutter documentation: https://docs.flutter.dev
- Check package documentation on pub.dev
- Open an issue on GitHub

## ✅ Checklist

Before running:
- [ ] Flutter installed and working
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Code generated (`build_runner`)
- [ ] Gemini API key added
- [ ] Fonts added to assets/fonts/
- [ ] Asset directories created
- [ ] Android device connected or emulator running

You're all set! Run `flutter run` and enjoy BotX! 🎉
