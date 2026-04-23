# BotX v2.0 - RunAnywhere SDK Implementation

## 🚀 Advanced AI Assistant with Local On-Device AI

BotX v2.0 is a fully offline, privacy-focused AI assistant powered by **RunAnywhere SDK** for local LLM inference directly on your Android device.

---

## 🎯 Key Features

### 1. **Local AI with RunAnywhere SDK** 🤖
- ✅ **100% Offline** - No internet required for AI
- ✅ **Privacy First** - All data stays on device
- ✅ **Fast Responses** - Optimized local inference
- ✅ **TinyLLaMA 1.1B** - Lightweight model for mobile
- ✅ **Context Memory** - Remembers conversation history
- ✅ **Streaming Responses** - Real-time typing effect

### 2. **Advanced Intent Classification** 🎯
- ✅ **Smart Intent Detection** - Understands user commands
- ✅ **Multi-Intent Support** - Handles complex requests
- ✅ **Parameter Extraction** - Extracts names, times, messages
- ✅ **Confidence Scoring** - Validates intent accuracy
- ✅ **Fallback to AI** - Uses LLM for unknown intents

### 3. **Voice Assistant** 🎤
- ✅ **Speech-to-Text** - Accurate voice recognition
- ✅ **Text-to-Speech** - Natural voice responses
- ✅ **Wake Word** - "Hey BotX" activation
- ✅ **Background Listening** - Always ready
- ✅ **Multi-Language** - English, Hindi, Marathi

### 4. **Smart App Control** 📱
- ✅ **20+ Apps** - Instagram, WhatsApp, YouTube, etc.
- ✅ **Send Messages** - WhatsApp integration
- ✅ **Make Calls** - Direct dialing
- ✅ **Open Settings** - System access
- ✅ **Natural Commands** - "Open Instagram and send message to John"

### 5. **AI-Powered Tools** 🛠️
- ✅ **Calculator** - Voice-activated calculations
- ✅ **Notes** - Create notes by voice
- ✅ **Reminders** - Set reminders naturally
- ✅ **Alarms** - Voice alarm setting
- ✅ **Translation** - Hindi ↔ English ↔ Marathi
- ✅ **Battery Status** - Check battery level
- ✅ **Date & Time** - Current date/time queries
- ✅ **Contact Search** - Find contacts by name

### 6. **Premium UI** 🎨
- ✅ **Futuristic Design** - Glassmorphism effects
- ✅ **Dark Mode** - Eye-friendly interface
- ✅ **Animated Avatar** - Interactive AI character
- ✅ **Smooth Transitions** - Fluid animations
- ✅ **Floating Mic** - Quick voice access
- ✅ **Typing Indicators** - Real-time feedback

---

## 🏗️ Architecture

### RunAnywhere Integration

```
User Input
    ↓
Intent Classifier (Local)
    ↓
┌─────────────┬──────────────┐
│   Intent    │   General    │
│   Actions   │   Query      │
└─────────────┴──────────────┘
       ↓              ↓
   Execute      RunAnywhere
   Action       Local LLM
       ↓              ↓
   Response ← Response
       ↓
   User
```

### Key Components

1. **RunAnywhereService** (`lib/core/ai/runanywhere_service.dart`)
   - Manages local LLM model
   - Handles inference
   - Maintains conversation context
   - Streams responses

2. **IntentClassifier** (`lib/core/ai/intent_classifier.dart`)
   - Classifies user intents
   - Extracts parameters
   - Calculates confidence
   - Routes to appropriate handler

3. **AIService** (`lib/features/chat/providers/ai_provider.dart`)
   - Combines intent + AI
   - Executes actions
   - Generates responses
   - Manages state

4. **VoiceService** (`lib/features/voice/services/voice_service.dart`)
   - Speech recognition
   - Text-to-speech
   - Wake word detection
   - Voice commands

---

## 📦 Installation

### Prerequisites

- Flutter 3.22+
- Dart 3.4+
- Android Studio
- Android device (API 21+)
- 2GB+ free storage (for AI model)

### Setup Steps

#### 1. Clone Repository

```bash
git clone https://github.com/vivekx11/BotxAi.git
cd BotxAi
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Download AI Model

The app will automatically download the TinyLLaMA model on first launch. Alternatively, manually download:

```bash
# Create models directory
mkdir -p assets/models

# Download TinyLLaMA 1.1B (example)
# Place model files in assets/models/
```

#### 4. Add Fonts

Download Poppins font and add to `assets/fonts/`:
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-SemiBold.ttf
- Poppins-Bold.ttf

#### 5. Run App

```bash
flutter run
```

---

## 🎯 Usage Examples

### Voice Commands

```
"Hey BotX, open WhatsApp"
"Hey BotX, send message to John saying hello"
"Hey BotX, what time is it?"
"Hey BotX, set alarm for 7 AM"
"Hey BotX, remind me to call mom tomorrow"
"Hey BotX, calculate 25 times 4"
"Hey BotX, translate hello to Hindi"
"Hey BotX, what's my battery level?"
```

### Chat Commands

```
User: "Open Instagram"
BotX: "Opening Instagram for you now..."

User: "Send message to Sarah saying I'll be late"
BotX: "I'll help you send a message to Sarah..."

User: "What's 15% of 200?"
BotX: "Opening calculator for: 15% of 200"

User: "Translate 'Good morning' to Hindi"
BotX: "Opening translator..."

User: "Set reminder to buy groceries"
BotX: "I'll set a reminder for: buy groceries"
```

### Complex Commands

```
User: "Hey BotX, open WhatsApp and send message to John saying hello"
BotX: [Opens WhatsApp] "I'll help you send 'hello' to John"

User: "Remind me to call mom at 5 PM tomorrow"
BotX: "I'll set a reminder to call mom at 5 PM tomorrow"

User: "What's the weather like and should I carry an umbrella?"
BotX: [Checks weather] "Let me check the weather for you..."
```

---

## 🔧 Configuration

### AI Model Settings

Edit `lib/core/ai/runanywhere_service.dart`:

```dart
// Change model
String _currentModel = 'tinyllama-1.1b'; // or 'phi-2', 'mistral-7b'

// Adjust context length
final int _maxHistoryLength = 10; // conversation turns
```

### Voice Settings

Edit `lib/features/voice/services/voice_service.dart`:

```dart
// Change wake word
static const String wakeWord = 'hey botx';

// Adjust speech rate
await _tts.setSpeechRate(0.5); // 0.1 - 1.0

// Adjust pitch
await _tts.setPitch(1.0); // 0.5 - 2.0
```

### Intent Confidence

Edit `lib/core/ai/intent_classifier.dart`:

```dart
// Adjust confidence thresholds
confidence: 0.95, // High confidence
confidence: 0.85, // Medium confidence
confidence: 0.5,  // Low confidence (fallback to AI)
```

---

## 🎨 Customization

### Add New Intent

1. **Define Intent Type** (`intent_classifier.dart`):

```dart
enum IntentType {
  // ... existing intents
  myNewIntent,
}
```

2. **Add Detection Logic**:

```dart
static bool _isMyNewIntent(String input) {
  return _containsAny(input, ['keyword1', 'keyword2']);
}
```

3. **Add to Classifier**:

```dart
if (_isMyNewIntent(lowerInput)) {
  return IntentResult(
    type: IntentType.myNewIntent,
    parameters: _extractMyParams(lowerInput),
    confidence: 0.9,
  );
}
```

4. **Handle Intent** (`ai_provider.dart`):

```dart
case IntentType.myNewIntent:
  return await _handleMyNewIntent(intent.parameters);
```

### Add New App

Edit `lib/core/utils/intent_launcher.dart`:

```dart
static final Map<String, String> _appPackages = {
  // ... existing apps
  'myapp': 'com.example.myapp',
};
```

### Customize UI Colors

Edit `lib/core/constants/app_colors.dart`:

```dart
static const darkAccent1 = Color(0xFFYOURCOLOR);
static const darkAccent2 = Color(0xFFYOURCOLOR);
```

---

## 🚀 Performance Optimization

### Model Selection

| Model | Size | Speed | Quality | Recommended |
|-------|------|-------|---------|-------------|
| TinyLLaMA 1.1B | 600MB | Fast | Good | ✅ Mobile |
| Phi-2 | 1.4GB | Medium | Better | Mid-range |
| Mistral 7B | 4GB | Slow | Best | High-end |

### Memory Management

```dart
// Unload model when not in use
await _runAnywhere.unloadModel();

// Clear conversation history
_runAnywhere.clearHistory();

// Limit context length
final int _maxHistoryLength = 10; // Reduce for lower memory
```

### Battery Optimization

- Wake word detection uses minimal battery
- Model inference is optimized for mobile
- Background listening can be disabled
- TTS/STT only active when needed

---

## 🔒 Privacy & Security

### Data Privacy

- ✅ **100% Local** - No data sent to cloud
- ✅ **No Tracking** - No analytics or telemetry
- ✅ **Encrypted Storage** - Hive with encryption
- ✅ **Secure Permissions** - Runtime permission requests
- ✅ **No Internet Required** - Fully offline operation

### Permissions Required

```xml
<!-- Essential -->
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.VIBRATE"/>

<!-- Optional -->
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
<uses-permission android:name="android.permission.SEND_SMS"/>
<uses-permission android:name="android.permission.INTERNET"/> <!-- Model download only -->
```

---

## 📊 Supported Intents

| Intent | Example | Parameters |
|--------|---------|------------|
| App Launch | "Open Instagram" | app name |
| Send Message | "Send message to John" | contact, message |
| Make Call | "Call Sarah" | contact |
| Set Reminder | "Remind me to..." | content, time |
| Set Alarm | "Set alarm for 7 AM" | hour, minute |
| Create Note | "Note: Buy milk" | content |
| Calculate | "Calculate 25 * 4" | expression |
| Translate | "Translate hello to Hindi" | text, language |
| Search Contact | "Find contact John" | name |
| Check Battery | "Battery level?" | - |
| Check Time | "What time is it?" | - |
| Check Date | "What's the date?" | - |

---

## 🛠️ Troubleshooting

### Model Not Loading

```bash
# Check model file exists
ls assets/models/

# Verify model format
# RunAnywhere supports GGUF, ONNX formats

# Check storage space
adb shell df -h
```

### Voice Not Working

```bash
# Check microphone permission
adb shell pm list permissions -g | grep RECORD_AUDIO

# Test speech recognition
# Go to Settings > Voice Assistant > Test Microphone
```

### App Not Opening

```bash
# Check app package name
adb shell pm list packages | grep instagram

# Verify intent launcher
# Check lib/core/utils/intent_launcher.dart
```

### Wake Word Not Detecting

```bash
# Increase detection frequency
# Edit voice_service.dart:
Timer.periodic(const Duration(seconds: 3), ...); // Reduce from 5 to 3

# Adjust wake word sensitivity
# Try alternative: "hey bot" instead of "hey botx"
```

---

## 📈 Roadmap

### v2.1 (Next Release)
- [ ] Multi-model support (Phi-2, Mistral)
- [ ] Custom wake word training
- [ ] Offline translation models
- [ ] Voice cloning for TTS
- [ ] Gesture controls

### v2.2 (Future)
- [ ] Image understanding (Vision models)
- [ ] Document Q&A
- [ ] Code generation
- [ ] Smart home integration
- [ ] Wearable support

### v3.0 (Long-term)
- [ ] Multi-agent system
- [ ] Plugin architecture
- [ ] Cloud sync (optional)
- [ ] iOS support
- [ ] Desktop version

---

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

### Development Setup

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build

# Run tests
flutter test

# Format code
flutter format lib/
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- **RunAnywhere Team** - For the amazing local LLM SDK
- **Flutter Team** - For the excellent framework
- **TinyLLaMA** - For the efficient mobile model
- **Community** - For feedback and contributions

---

## 📞 Support

- **GitHub Issues**: https://github.com/vivekx11/BotxAi/issues
- **Documentation**: See `/docs` folder
- **Email**: support@botx.ai (example)

---

## 🌟 Star Us!

If you find BotX useful, please star the repository! ⭐

---

**Built with ❤️ using Flutter & RunAnywhere SDK**

**Version**: 2.0.0

**Last Updated**: 2026-04-22
