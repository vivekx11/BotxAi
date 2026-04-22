# BotX Development Guide

A comprehensive guide for developers working on the BotX project.

## 🎯 Project Philosophy

BotX follows these principles:
- **Clean Architecture** - Separation of concerns
- **Feature-First** - Organized by features, not layers
- **Declarative UI** - Flutter's widget composition
- **Immutable State** - Riverpod state management
- **Type Safety** - Leverage Dart's type system

---

## 📁 Project Structure Explained

```
lib/
├── main.dart                    # App entry, initialization
├── app.dart                     # Root widget, providers
│
├── core/                        # Shared across features
│   ├── constants/              # App-wide constants
│   ├── router/                 # Navigation configuration
│   ├── theme/                  # Theme and styling
│   ├── utils/                  # Utility functions
│   └── network/                # API clients
│
├── features/                    # Feature modules
│   ├── auth/                   # Authentication & onboarding
│   ├── chat/                   # Main chat feature
│   │   ├── data/              # Data layer (repositories)
│   │   ├── domain/            # Business logic (models)
│   │   ├── providers/         # State management
│   │   ├── screens/           # UI screens
│   │   └── widgets/           # Feature-specific widgets
│   ├── voice/                  # Voice assistant
│   ├── tools/                  # Smart tools
│   ├── settings/               # App settings
│   └── shared/                 # Shared widgets
│
└── generated/                   # Auto-generated code
```

### Why This Structure?

1. **Feature-First**: Easy to find related code
2. **Scalable**: Add features without affecting others
3. **Testable**: Each feature can be tested independently
4. **Maintainable**: Clear boundaries and responsibilities

---

## 🏗️ Architecture Patterns

### State Management (Riverpod)

```dart
// 1. Define a provider
final counterProvider = StateProvider<int>((ref) => 0);

// 2. Read in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}

// 3. Update state
ref.read(counterProvider.notifier).state++;
```

### Data Flow

```
User Action → Provider → Repository → API/Storage
                ↓
            UI Update
```

### Example: Chat Message Flow

```dart
// 1. User sends message
onSend(text) {
  ref.read(chatProvider.notifier).sendMessage(text);
}

// 2. Provider processes
class ChatNotifier extends StateNotifier {
  Future<void> sendMessage(String text) async {
    // Save user message
    await _repository.saveMessage(userMessage);
    
    // Get AI response
    final response = await _aiService.sendMessage(text);
    
    // Save bot message
    await _repository.saveMessage(botMessage);
    
    // Update UI
    state = AsyncValue.data(messages);
  }
}

// 3. UI updates automatically
final messages = ref.watch(chatProvider);
```

---

## 🎨 Adding a New Feature

### Step 1: Create Feature Structure

```bash
lib/features/my_feature/
├── data/
│   └── my_repository.dart
├── domain/
│   └── my_model.dart
├── providers/
│   └── my_provider.dart
├── screens/
│   └── my_screen.dart
└── widgets/
    └── my_widget.dart
```

### Step 2: Create Model

```dart
// lib/features/my_feature/domain/my_model.dart
class MyModel {
  final String id;
  final String name;
  
  MyModel({required this.id, required this.name});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
  
  factory MyModel.fromJson(Map<String, dynamic> json) => MyModel(
    id: json['id'],
    name: json['name'],
  );
}
```

### Step 3: Create Repository

```dart
// lib/features/my_feature/data/my_repository.dart
class MyRepository {
  final Box _box = Hive.box('my_feature');
  
  Future<List<MyModel>> getAll() async {
    final data = _box.get('items', defaultValue: []) as List;
    return data.map((json) => MyModel.fromJson(json)).toList();
  }
  
  Future<void> save(MyModel item) async {
    final items = await getAll();
    items.add(item);
    await _box.put('items', items.map((i) => i.toJson()).toList());
  }
}
```

### Step 4: Create Provider

```dart
// lib/features/my_feature/providers/my_provider.dart
final myRepositoryProvider = Provider((ref) => MyRepository());

final myItemsProvider = StateNotifierProvider<MyNotifier, AsyncValue<List<MyModel>>>((ref) {
  return MyNotifier(ref.watch(myRepositoryProvider));
});

class MyNotifier extends StateNotifier<AsyncValue<List<MyModel>>> {
  final MyRepository _repository;
  
  MyNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }
  
  Future<void> _load() async {
    try {
      final items = await _repository.getAll();
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> add(MyModel item) async {
    await _repository.save(item);
    await _load();
  }
}
```

### Step 5: Create Screen

```dart
// lib/features/my_feature/screens/my_screen.dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(myItemsProvider);
    
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: itemsAsync.when(
            data: (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index].name),
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
```

### Step 6: Add Route

```dart
// lib/core/router/app_router.dart
GoRoute(
  path: '/my-feature',
  name: 'my-feature',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const MyScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
),
```

---

## 🎨 UI Development Guidelines

### Using Glass Containers

```dart
GlassContainer(
  padding: const EdgeInsets.all(16),
  child: Text('Content'),
)
```

### Using Animated Background

```dart
AnimatedGradientBackground(
  child: YourContent(),
)
```

### Creating Custom Widgets

```dart
class MyCustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  
  const MyCustomWidget({
    super.key,
    required this.title,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Text(title),
      ),
    );
  }
}
```

### Adding Animations

```dart
import 'package:flutter_animate/flutter_animate.dart';

Widget build(BuildContext context) {
  return Container()
    .animate()
    .fadeIn(duration: 300.ms)
    .slideY(begin: 0.2, end: 0);
}
```

---

## 🤖 Working with AI

### Adding New Intents

```dart
// lib/features/chat/providers/ai_provider.dart

Future<String?> _handleIntent(String message) async {
  final lowerMessage = message.toLowerCase().trim();
  
  // Add your new intent
  if (lowerMessage.contains('your keyword')) {
    return 'Your response';
  }
  
  // Existing intents...
  return null;
}
```

### Customizing AI Personality

```dart
// lib/features/chat/providers/ai_provider.dart

AIService() {
  _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
    systemInstruction: Content.system(
      'Your custom personality here...'
    ),
  );
}
```

### Adding Offline Responses

```dart
// lib/features/chat/providers/ai_provider.dart

String _getOfflineFallback(String message) {
  final offlineResponses = {
    'your keyword': 'Your response',
    // Add more...
  };
  
  for (final entry in offlineResponses.entries) {
    if (lowerMessage.contains(entry.key)) {
      return entry.value;
    }
  }
  
  return 'Default offline response';
}
```

---

## 🎤 Implementing Voice Features

### Speech-to-Text

```dart
import 'package:speech_to_text/speech_to_text.dart';

class STTService {
  final SpeechToText _speech = SpeechToText();
  
  Future<bool> initialize() async {
    return await _speech.initialize();
  }
  
  Future<void> listen(Function(String) onResult) async {
    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 2),
    );
  }
  
  Future<void> stop() async {
    await _speech.stop();
  }
}
```

### Text-to-Speech

```dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  
  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }
  
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }
  
  Future<void> stop() async {
    await _tts.stop();
  }
}
```

---

## 💾 Working with Storage

### Saving Data

```dart
final box = Hive.box('my_box');

// Save simple value
await box.put('key', 'value');

// Save list
await box.put('items', [1, 2, 3]);

// Save map
await box.put('user', {'name': 'John', 'age': 30});
```

### Reading Data

```dart
// Read with default
final value = box.get('key', defaultValue: 'default');

// Read list
final items = box.get('items', defaultValue: []) as List;

// Read map
final user = box.get('user', defaultValue: {}) as Map;
```

### Deleting Data

```dart
// Delete single key
await box.delete('key');

// Clear all
await box.clear();
```

---

## 🌐 Making API Calls

### Using Dio Client

```dart
final dioClient = DioClient();

// GET request
final response = await dioClient.get(
  'https://api.example.com/data',
  queryParameters: {'id': '123'},
);

// POST request
final response = await dioClient.post(
  'https://api.example.com/data',
  data: {'name': 'John'},
);
```

### Creating New API Service

```dart
class MyApiService {
  final DioClient _client = DioClient();
  static const String _baseUrl = 'https://api.example.com';
  
  Future<Map<String, dynamic>> getData(String id) async {
    try {
      final response = await _client.get(
        '$_baseUrl/data/$id',
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
```

---

## 🎨 Theming & Styling

### Using Theme Colors

```dart
// In widget
final isDark = Theme.of(context).brightness == Brightness.dark;
final color = isDark ? AppColors.darkAccent1 : AppColors.lightAccent1;
```

### Adding New Colors

```dart
// lib/core/constants/app_colors.dart
static const myNewColor = Color(0xFF123456);
```

### Creating Custom Gradients

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.darkAccent1, AppColors.darkAccent2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

---

## 🧪 Testing Guidelines

### Unit Test Example

```dart
// test/features/chat/providers/chat_provider_test.dart
void main() {
  group('ChatNotifier', () {
    test('sends message successfully', () async {
      final container = ProviderContainer();
      final notifier = container.read(chatMessagesProvider.notifier);
      
      await notifier.sendMessage('Hello');
      
      final state = container.read(chatMessagesProvider);
      expect(state.value?.length, 2); // User + bot message
    });
  });
}
```

### Widget Test Example

```dart
// test/features/chat/widgets/message_bubble_test.dart
void main() {
  testWidgets('MessageBubble displays content', (tester) async {
    final message = ChatMessage(
      id: '1',
      role: 'user',
      content: 'Test message',
      timestamp: DateTime.now(),
    );
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(message: message),
        ),
      ),
    );
    
    expect(find.text('Test message'), findsOneWidget);
  });
}
```

---

## 🐛 Debugging Tips

### Logging

```dart
// Use print for simple debugging
print('Debug: $variable');

// Use debugPrint for production
debugPrint('Info: $message');

// Log errors
print('Error: $error\nStack: $stackTrace');
```

### Riverpod DevTools

```dart
// Enable logging
final container = ProviderContainer(
  observers: [MyObserver()],
);

class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('Provider ${provider.name ?? provider.runtimeType} updated');
  }
}
```

### Flutter DevTools

```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 🚀 Performance Optimization

### Lazy Loading

```dart
// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### Const Constructors

```dart
// Use const when possible
const Text('Static text')
const SizedBox(height: 16)
```

### Avoid Rebuilds

```dart
// Use Consumer for targeted rebuilds
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(myProvider);
    return Text('$value');
  },
)
```

---

## 📦 Adding Dependencies

### 1. Add to pubspec.yaml

```yaml
dependencies:
  my_package: ^1.0.0
```

### 2. Get packages

```bash
flutter pub get
```

### 3. Import and use

```dart
import 'package:my_package/my_package.dart';
```

---

## 🔧 Common Tasks

### Adding a New Screen

1. Create screen file in `features/[feature]/screens/`
2. Add route in `app_router.dart`
3. Add navigation call where needed

### Adding a New Provider

1. Create provider file in `features/[feature]/providers/`
2. Define provider
3. Use in widgets with `ref.watch()`

### Adding a New Model

1. Create model file in `features/[feature]/domain/`
2. Add Hive annotations if needed
3. Run build_runner if using code generation

### Updating Theme

1. Edit `app_colors.dart` for colors
2. Edit `app_theme.dart` for theme configuration
3. Hot reload to see changes

---

## 📚 Resources

### Official Documentation
- [Flutter Docs](https://docs.flutter.dev)
- [Dart Docs](https://dart.dev/guides)
- [Riverpod Docs](https://riverpod.dev)

### Package Documentation
- [go_router](https://pub.dev/packages/go_router)
- [hive](https://pub.dev/packages/hive)
- [dio](https://pub.dev/packages/dio)
- [flutter_animate](https://pub.dev/packages/flutter_animate)

### Learning Resources
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Riverpod Examples](https://riverpod.dev/docs/essentials/first_request)
- [Flutter Samples](https://flutter.github.io/samples/)

---

## 🤝 Contributing Guidelines

### Code Style

- Use `flutter format` before committing
- Follow Dart style guide
- Add comments for complex logic
- Use meaningful variable names

### Commit Messages

```
feat: Add new feature
fix: Fix bug in chat
docs: Update README
style: Format code
refactor: Restructure chat provider
test: Add unit tests
chore: Update dependencies
```

### Pull Request Process

1. Create feature branch
2. Make changes
3. Test thoroughly
4. Format code
5. Create PR with description
6. Wait for review

---

## 🆘 Getting Help

### Common Issues

**Issue**: Build errors after adding dependency
**Solution**: Run `flutter clean && flutter pub get`

**Issue**: Hot reload not working
**Solution**: Stop and restart app

**Issue**: Provider not updating
**Solution**: Check if using `ref.watch()` not `ref.read()`

### Where to Ask

1. Check documentation first
2. Search existing issues
3. Ask in Flutter Discord
4. Post on Stack Overflow
5. Create GitHub issue

---

**Happy Coding! 🚀**

For more information, see:
- [README.md](README.md) - Full documentation
- [QUICKSTART.md](QUICKSTART.md) - Quick setup
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project overview
