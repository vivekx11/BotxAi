# RunAnywhere SDK Implementation Guide

## 🎯 Overview

This document explains how BotX v2.0 integrates RunAnywhere SDK for local on-device AI.

---

## 📁 Key Files Created

### 1. AI Core (`lib/core/ai/`)

#### `runanywhere_service.dart`
- **Purpose**: Manages RunAnywhere SDK and local LLM
- **Features**:
  - Model initialization and loading
  - Inference generation
  - Conversation context management
  - Streaming responses
  - Memory management

**Key Methods**:
```dart
Future<bool> initialize()              // Initialize SDK
Future<bool> loadModel()               // Load AI model
Future<String> generateResponse()      // Generate response
Stream<String> generateResponseStream() // Stream response
void clearHistory()                    // Clear context
Future<void> unloadModel()             // Free memory
```

#### `intent_classifier.dart`
- **Purpose**: Classify user intents before AI processing
- **Features**:
  - 14 intent types
  - Parameter extraction
  - Confidence scoring
  - Pattern matching

**Supported Intents**:
1. App Launch
2. Send Message
3. Make Call
4. Set Reminder
5. Set Alarm
6. Create Note
7. Calculate
8. Translate
9. Search Contact
10. Check Battery
11. Check Time
12. Check Date
13. Open Settings
14. General Query

### 2. AI Provider (`lib/features/chat/providers/`)

#### `ai_provider.dart`
- **Purpose**: Combines RunAnywhere + Intent Classification
- **Flow**:
  1. Receive user message
  2. Classify intent
  3. Execute action OR use AI
  4. Return response

**Integration Pattern**:
```dart
// Step 1: Classify
final intent = IntentClassifier.classify(message);

// Step 2: Handle or delegate to AI
final response = await _handleIntent(intent) 
                 ?? await _runAnywhere.generateResponse(message);

// Step 3: Return
return response;
```

### 3. Voice Service (`lib/features/voice/services/`)

#### `voice_service.dart`
- **Purpose**: Complete voice assistant functionality
- **Features**:
  - Speech-to-Text (STT)
  - Text-to-Speech (TTS)
  - Wake word detection ("Hey BotX")
  - Background listening
  - Multi-language support

**Voice States**:
- `idle` - Ready
- `listening` - Recording audio
- `processing` - Analyzing speech
- `speaking` - Playing TTS
- `wakeWordListening` - Detecting wake word

---

## 🔄 Data Flow

### Chat Flow

```
User Types Message
       ↓
Intent Classifier
       ↓
   ┌───┴───┐
   │       │
Intent   General
Action   Query
   │       │
   │   RunAnywhere
   │    Local LLM
   │       │
   └───┬───┘
       ↓
   Response
       ↓
Display to User
```

### Voice Flow

```
User Says "Hey BotX"
       ↓
Wake Word Detected
       ↓
Start Listening
       ↓
Speech to Text
       ↓
Intent Classifier
       ↓
Execute/AI Response
       ↓
Text to Speech
       ↓
Speak to User
```

---

## 🚀 RunAnywhere SDK Integration

### Current Implementation

The current implementation uses a **simulation layer** that demonstrates the architecture. To integrate the actual RunAnywhere SDK:

### Step 1: Add RunAnywhere SDK

```yaml
# pubspec.yaml
dependencies:
  runanywhere_sdk:
    git:
      url: https://github.com/RunanywhereAI/runanywhere-sdks.git
      path: flutter
```

### Step 2: Initialize SDK

```dart
// lib/core/ai/runanywhere_service.dart

import 'package:runanywhere_sdk/runanywhere_sdk.dart';

class RunAnywhereService {
  late RunAnywhereClient _client;
  late ModelInstance _model;
  
  Future<bool> initialize() async {
    try {
      // Initialize RunAnywhere client
      _client = RunAnywhereClient();
      await _client.initialize();
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> loadModel({String? modelName}) async {
    try {
      // Load model from assets or download
      _model = await _client.loadModel(
        modelName: modelName ?? 'tinyllama-1.1b',
        modelPath: 'assets/models/',
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<String> generateResponse(String prompt) async {
    try {
      // Build context
      final context = _buildContext();
      
      // Generate response
      final response = await _model.generate(
        prompt: prompt,
        context: context,
        maxTokens: 256,
        temperature: 0.7,
      );
      
      return response.text;
    } catch (e) {
      return 'Error generating response';
    }
  }
  
  Stream<String> generateResponseStream(String prompt) async* {
    try {
      final context = _buildContext();
      
      // Stream tokens
      await for (final token in _model.generateStream(
        prompt: prompt,
        context: context,
        maxTokens: 256,
        temperature: 0.7,
      )) {
        yield token.text;
      }
    } catch (e) {
      yield 'Error generating response';
    }
  }
}
```

### Step 3: Download Model

```dart
// Download model on first launch
Future<void> downloadModel() async {
  final downloader = ModelDownloader();
  
  await downloader.download(
    modelName: 'tinyllama-1.1b',
    url: 'https://huggingface.co/...',
    savePath: 'assets/models/',
    onProgress: (progress) {
      print('Download: ${progress}%');
    },
  );
}
```

---

## 🎯 Intent Classification Details

### How It Works

1. **Pattern Matching**: Checks for keywords
2. **Parameter Extraction**: Uses regex to extract data
3. **Confidence Scoring**: Rates match quality
4. **Fallback**: Unknown intents go to AI

### Example: Send Message Intent

```dart
Input: "send message to John saying hello"

Step 1: Detect Intent
- Contains "send message" ✓
- Contains "to" + name ✓
- Intent: sendMessage

Step 2: Extract Parameters
- contact: "John"
- message: "hello"

Step 3: Execute
- Open WhatsApp
- Pre-fill message to John
- Return confirmation
```

### Adding Custom Intent

```dart
// 1. Add to enum
enum IntentType {
  myCustomIntent,
}

// 2. Add detection
static bool _isMyCustomIntent(String input) {
  return input.contains('my keyword');
}

// 3. Add to classifier
if (_isMyCustomIntent(lowerInput)) {
  return IntentResult(
    type: IntentType.myCustomIntent,
    parameters: {'param': 'value'},
    confidence: 0.9,
  );
}

// 4. Handle in AI provider
case IntentType.myCustomIntent:
  return _handleMyCustomIntent(params);
```

---

## 🎤 Voice Implementation Details

### Wake Word Detection

```dart
// Continuous listening loop
Timer.periodic(Duration(seconds: 5), (timer) {
  // Listen for 3 seconds
  await _speech.listen(
    onResult: (result) {
      if (result.contains('hey botx')) {
        _onWakeWordDetected();
      }
    },
    listenFor: Duration(seconds: 3),
  );
});
```

### Speech Recognition

```dart
// Start listening
await _speech.listen(
  onResult: (result) {
    final text = result.recognizedWords;
    if (result.finalResult) {
      onResult?.call(text);
    }
  },
  listenFor: Duration(seconds: 30),
  pauseFor: Duration(seconds: 3),
  localeId: 'en_IN',
);
```

### Text-to-Speech

```dart
// Configure TTS
await _tts.setLanguage('en-IN');
await _tts.setSpeechRate(0.5);
await _tts.setPitch(1.0);

// Speak
await _tts.speak(text);
```

---

## 🔧 Configuration Options

### Model Selection

```dart
// Lightweight (600MB)
_currentModel = 'tinyllama-1.1b';

// Medium (1.4GB)
_currentModel = 'phi-2';

// Large (4GB)
_currentModel = 'mistral-7b';
```

### Context Length

```dart
// Short context (faster)
final int _maxHistoryLength = 5;

// Long context (better memory)
final int _maxHistoryLength = 20;
```

### Response Generation

```dart
// Fast responses
maxTokens: 128,
temperature: 0.5,

// Detailed responses
maxTokens: 512,
temperature: 0.8,
```

---

## 📊 Performance Tips

### Memory Management

```dart
// Unload model when not in use
if (appInBackground) {
  await _runAnywhere.unloadModel();
}

// Clear old history
if (_conversationHistory.length > 20) {
  _conversationHistory.removeRange(0, 10);
}
```

### Battery Optimization

```dart
// Reduce wake word frequency
Timer.periodic(Duration(seconds: 10), ...); // Instead of 5

// Disable when not needed
if (batteryLow) {
  voiceService.disableWakeWord();
}
```

### Response Speed

```dart
// Use streaming for better UX
Stream<String> response = ai.generateResponseStream(prompt);

// Show partial responses immediately
await for (final chunk in response) {
  updateUI(chunk);
}
```

---

## 🐛 Debugging

### Enable Logging

```dart
// In runanywhere_service.dart
debugPrint('🤖 Initializing...');
debugPrint('✅ Model loaded');
debugPrint('❌ Error: $e');
```

### Test Intent Classification

```dart
// Test classifier
final intent = IntentClassifier.classify('open instagram');
print('Intent: ${intent.type}');
print('Params: ${intent.parameters}');
print('Confidence: ${intent.confidence}');
```

### Monitor Voice State

```dart
voiceService.onStateChanged = (state) {
  print('Voice State: $state');
};
```

---

## 🚀 Next Steps

1. **Integrate Real SDK**: Replace simulation with actual RunAnywhere SDK
2. **Download Models**: Add model download functionality
3. **Test Performance**: Benchmark on different devices
4. **Optimize Memory**: Profile and reduce memory usage
5. **Add Features**: Implement remaining tools

---

## 📚 Resources

- **RunAnywhere SDK**: https://github.com/RunanywhereAI/runanywhere-sdks
- **TinyLLaMA**: https://github.com/jzhang38/TinyLlama
- **Flutter TTS**: https://pub.dev/packages/flutter_tts
- **Speech to Text**: https://pub.dev/packages/speech_to_text

---

**Implementation Status**: ✅ Architecture Complete, Ready for SDK Integration

**Version**: 2.0.0

**Last Updated**: 2026-04-22
