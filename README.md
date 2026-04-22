# BotX - AI-Powered Mobile Assistant
--------------------------------------

A production-ready Flutter mobile AI assistant app with voice control, chat interface, and smart tools. Built for Android (API 21+).

## 🚀 Features
---------------------------------------
### Core Features
- **AI Chat Interface** - Powered by Google Gemini 1.5 Flash
- **Voice Assistant** - Speech-to-text and text-to-speech capabilities
- **Smart App Control** - Open and control apps via voice or text commands
- **Offline Mode** - Basic functionality without internet connection
- **Beautiful UI** - Glassmorphism design with animated gradients

### Smart Tools
- **Calculator** - Standard and scientific calculations
- **Notes** - Create and manage notes with color coding
- **Weather** - Current weather and 5-day forecast
- **Translator** - Multi-language translation with voice support
- **Battery Monitor** - Real-time battery status
- **Contacts** - Quick access to contacts

### AI Capabilities
- Natural language understanding
- Intent classification for app control
- Context-aware suggestions
- Streaming responses
- Multi-turn conversations

## 📋 Prerequisites

- Flutter SDK 3.22 or higher
- Dart SDK 3.4 or higher
- Android Studio / VS Code
- Android device or emulator (API 21+)
- Google Gemini API key
- OpenWeatherMap API key (optional)

## 🛠️ Setup Instructions

### 1. Clone and Install Dependencies

```bash
# Clone the repository
git clone <repository-url>
cd botx

# Install dependencies
flutter pub get

# Generate code (for Hive and Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Configure API Keys

#### Gemini AI API Key
1. Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Open `lib/features/chat/providers/ai_provider.dart`
3. Replace `YOUR_GEMINI_API_KEY` with your actual key:
```dart
static const String _apiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
```

#### OpenWeatherMap API Key (Optional)
1. Get your API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Open `lib/core/network/weather_api.dart`
3. Replace `YOUR_OPENWEATHERMAP_API_KEY` with your actual key:
```dart
static const String _apiKey = 'YOUR_ACTUAL_OPENWEATHERMAP_API_KEY';
```

### 3. Add Assets

Create the following asset directories and add placeholder files:

```bash
mkdir -p assets/lottie
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
```

#### Lottie Animations (Optional)
Download free Lottie animations from [LottieFiles](https://lottiefiles.com/) and add:
- `assets/lottie/ai-robot.json` - AI assistant animation
- `assets/lottie/loading.json` - Loading animation
- `assets/lottie/voice-wave.json` - Voice waveform animation

#### Fonts
Download Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins) and add:
- `assets/fonts/Poppins-Regular.ttf`
- `assets/fonts/Poppins-Medium.ttf`
- `assets/fonts/Poppins-SemiBold.ttf`
- `assets/fonts/Poppins-Bold.ttf`

### 4. Android Configuration

The `AndroidManifest.xml` is already configured with all necessary permissions. Ensure your `android/app/build.gradle` has:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.botx"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 5. Run the App

```bash
# Check for issues
flutter doctor

# Run on connected device
flutter run

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle --release
```

## 📱 App Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # Root app widget
├── core/
│   ├── constants/                     # App constants
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   ├── router/
│   │   └── app_router.dart           # Navigation configuration
│   ├── theme/
│   │   ├── app_theme.dart            # Theme configuration
│   │   └── glass_theme.dart          # Glassmorphism styles
│   ├── utils/                        # Utility functions
│   │   ├── intent_launcher.dart      # App control
│   │   ├── permission_utils.dart     # Permission handling
│   │   ├── date_utils.dart           # Date formatting
│   │   └── battery_utils.dart        # Battery monitoring
│   └── network/
│       ├── dio_client.dart           # HTTP client
│       └── weather_api.dart          # Weather API
├── features/
│   ├── auth/
│   │   └── screens/
│   │       ├── splash_screen.dart    # Splash screen
│   │       └── welcome_screen.dart   # Onboarding
│   ├── chat/
│   │   ├── data/
│   │   │   └── chat_repository.dart  # Chat persistence
│   │   ├── domain/
│   │   │   ├── chat_message.dart     # Message model
│   │   │   └── suggestion_engine.dart # Suggestions
│   │   ├── providers/
│   │   │   ├── ai_provider.dart      # AI service
│   │   │   └── chat_provider.dart    # Chat state
│   │   ├── screens/
│   │   │   └── chat_screen.dart      # Main chat UI
│   │   └── widgets/
│   │       ├── message_bubble.dart
│   │       ├── typing_indicator.dart
│   │       ├── suggestion_chips.dart
│   │       └── chat_input_bar.dart
│   ├── voice/
│   │   └── screens/
│   │       └── voice_screen.dart     # Voice assistant
│   ├── tools/
│   │   ├── screens/
│   │   │   └── tools_dashboard.dart  # Tools grid
│   │   ├── calculators/
│   │   │   └── calculator_screen.dart
│   │   ├── notes/
│   │   │   └── notes_screen.dart
│   │   ├── weather/
│   │   │   └── weather_screen.dart
│   │   └── translator/
│   │       └── screens/
│   │           └── translator_screen.dart
│   ├── settings/
│   │   ├── providers/
│   │   │   └── settings_provider.dart # Settings state
│   │   └── screens/
│   │       ├── settings_screen.dart
│   │       ├── about_screen.dart
│   │       └── profile_screen.dart
│   └── shared/
│       └── widgets/
│           ├── glass_container.dart   # Reusable glass widget
│           └── animated_gradient_bg.dart # Background
```

## 🎨 Design System

### Colors
- **Dark Mode** (Primary)
  - Background: `#0A0A14`
  - Surface: `#13131F`
  - Accent Purple: `#7C5CFC`
  - Accent Teal: `#00D4C8`
  - Text: `#F0F0FF`

- **Light Mode**
  - Background: `#F5F5F9`
  - Surface: `#FFFFFF`
  - Accent Purple: `#6B4CE6`
  - Accent Teal: `#00BDB0`
  - Text: `#1A1A2E`

### Typography
- Font Family: Poppins
- Sizes: 12-48px
- Weights: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing
- XS: 4px
- S: 8px
- M: 16px
- L: 24px
- XL: 32px
- XXL: 48px

## 🤖 AI Integration

### Gemini AI Configuration
The app uses Google's Gemini 1.5 Flash model with:
- System prompt defining BotX personality
- Multi-turn conversation support
- Streaming responses
- Intent classification before AI processing

### Intent Classification
The app recognizes these intents locally:
- **App Launch**: "open instagram", "open youtube"
- **Time/Date**: "what time is it", "what's the date"
- **Battery**: "battery level", "is my phone charging"
- **Calculator**: "calculate 25 * 4"
- **Weather**: "what's the weather"
- **Translation**: "translate hello to spanish"

### Offline Fallback
When offline, the app provides:
- Basic greetings and responses
- App launching
- Time/date queries
- Battery status
- Pre-defined Q&A pairs

## 🎤 Voice Features

### Speech-to-Text
- Powered by `speech_to_text` package
- Supports multiple languages (en_IN, hi_IN, mr_IN)
- 30-second listening duration
- 2-second pause detection

### Text-to-Speech
- Powered by `flutter_tts` package
- Configurable speed (0.1-1.0)
- Configurable pitch (0.5-2.0)
- Queue mode for long responses

### Wake Word (Planned)
- Background listening for "hey botx"
- Isolate-based implementation
- Energy-based audio detection

## 📦 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| go_router | ^14.0.0 | Navigation |
| google_generative_ai | ^0.4.3 | AI chat |
| speech_to_text | ^6.6.2 | Voice input |
| flutter_tts | ^4.0.2 | Voice output |
| hive_flutter | ^1.1.0 | Local storage |
| flutter_animate | ^4.5.0 | Animations |
| glassmorphism | ^3.0.0 | UI effects |
| dio | ^5.4.3 | HTTP client |
| permission_handler | ^11.3.1 | Permissions |

## 🔒 Permissions

The app requests these permissions:
- **Microphone** - Voice commands
- **Internet** - AI and weather API
- **Notifications** - Reminders and alerts
- **Camera** - Profile picture (optional)
- **Contacts** - Quick access (optional)

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 🚀 Building for Production

### Release APK
```bash
flutter build apk --release --split-per-abi
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Code Signing
1. Create a keystore:
```bash
keytool -genkey -v -keystore ~/botx-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias botx
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=botx
storeFile=<path-to-keystore>
```

3. Update `android/app/build.gradle` to use the keystore

## 📝 TODO / Future Enhancements

- [ ] Implement full voice service with STT/TTS
- [ ] Add wake word detection
- [ ] Implement notes CRUD with Hive
- [ ] Add weather API integration
- [ ] Implement translation service
- [ ] Add contacts integration
- [ ] Implement reminders and alarms
- [ ] Add chat export functionality
- [ ] Implement user authentication
- [ ] Add cloud sync for chat history
- [ ] Implement custom wake word training
- [ ] Add more Lottie animations
- [ ] Implement haptic feedback
- [ ] Add accessibility features
- [ ] Implement widget support
- [ ] Add shortcuts and quick actions

## 🐛 Known Issues

- Lottie animations require asset files (placeholders used)
- Weather API requires valid API key
- Voice features need physical device for testing
- Some MCP tools may require additional setup

## 📄 License

This project is created for demonstration purposes. Modify and use as needed.

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a pull request

## 📧 Support

For issues and questions:
- Open an issue on GitHub
- Check existing documentation
- Review Flutter and package documentation

## 🙏 Acknowledgments

- Google Gemini AI for the AI capabilities
- Flutter team for the amazing framework
- All open-source package contributors

---

**Built with ❤️ using Flutter**
