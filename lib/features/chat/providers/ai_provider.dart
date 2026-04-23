import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/runanywhere_service.dart';
import '../../../core/ai/intent_classifier.dart';
import '../../../core/utils/intent_launcher.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/battery_utils.dart';

final aiServiceProvider = Provider<AIService>((ref) => AIService());

/// AI Service that combines RunAnywhere SDK with Intent Classification
class AIService {
  final RunAnywhereService _runAnywhere = RunAnywhereService();
  bool _isInitialized = false;

  /// Initialize AI service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      final success = await _runAnywhere.initialize();
      if (success) {
        await _runAnywhere.loadModel();
        _isInitialized = true;
      }
      return success;
    } catch (e) {
      print('AI Service initialization error: $e');
      return false;
    }
  }

  /// Process user message and generate response
  Future<String> sendMessage(String message) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Step 1: Classify intent
      final intent = IntentClassifier.classify(message);
      
      // Step 2: Handle intent-based actions
      final intentResponse = await _handleIntent(intent);
      if (intentResponse != null) {
        return intentResponse;
      }
      
      // Step 3: Use RunAnywhere AI for general queries
      return await _runAnywhere.generateResponse(message);
    } catch (e) {
      print('Error in sendMessage: $e');
      return 'I apologize, but I encountered an error. Please try again.';
    }
  }

  /// Stream response for real-time typing effect
  Stream<String> sendMessageStream(String message) async* {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Classify intent first
      final intent = IntentClassifier.classify(message);
      
      // Handle intent-based actions
      final intentResponse = await _handleIntent(intent);
      if (intentResponse != null) {
        // Stream the intent response
        yield* _streamText(intentResponse);
        return;
      }
      
      // Use RunAnywhere AI for general queries
      yield* _runAnywhere.generateResponseStream(message);
    } catch (e) {
      yield 'I apologize, but I encountered an error. Please try again.';
    }
  }

  /// Handle classified intents
  Future<String?> _handleIntent(IntentResult intent) async {
    switch (intent.type) {
      case IntentType.appLaunch:
        return await _handleAppLaunch(intent.parameters);
      
      case IntentType.sendMessage:
        return await _handleSendMessage(intent.parameters);
      
      case IntentType.makeCall:
        return await _handleMakeCall(intent.parameters);
      
      case IntentType.checkBattery:
        return await BatteryUtils.respondToBatteryQuery();
      
      case IntentType.checkTime:
        return AppDateUtils.respondToTimeQuery();
      
      case IntentType.checkDate:
        return AppDateUtils.respondToDateQuery();
      
      case IntentType.setReminder:
        return _handleSetReminder(intent.parameters);
      
      case IntentType.setAlarm:
        return _handleSetAlarm(intent.parameters);
      
      case IntentType.createNote:
        return _handleCreateNote(intent.parameters);
      
      case IntentType.calculate:
        return _handleCalculate(intent.parameters);
      
      case IntentType.translate:
        return _handleTranslate(intent.parameters);
      
      case IntentType.searchContact:
        return _handleSearchContact(intent.parameters);
      
      case IntentType.openSettings:
        return await IntentLauncher.openApp('settings');
      
      case IntentType.generalQuery:
      case IntentType.unknown:
        return null; // Let AI handle it
    }
  }

  /// Handle app launch
  Future<String> _handleAppLaunch(Map<String, dynamic> params) async {
    final appName = params['app'] as String?;
    if (appName == null || appName.isEmpty) {
      return 'Which app would you like me to open?';
    }
    
    return await IntentLauncher.openApp(appName);
  }

  /// Handle send message
  Future<String> _handleSendMessage(Map<String, dynamic> params) async {
    final contact = params['contact'] as String?;
    final message = params['message'] as String?;
    
    if (contact == null) {
      return 'Who would you like to send a message to?';
    }
    
    if (message == null) {
      return 'What message would you like to send to $contact?';
    }
    
    // Open WhatsApp with message
    return await IntentLauncher.sendSMS('', message: message);
  }

  /// Handle make call
  Future<String> _handleMakeCall(Map<String, dynamic> params) async {
    final contact = params['contact'] as String?;
    
    if (contact == null) {
      return 'Who would you like to call?';
    }
    
    return await IntentLauncher.makeCall('');
  }

  /// Handle set reminder
  String _handleSetReminder(Map<String, dynamic> params) {
    final content = params['content'] as String?;
    final when = params['when'] as String?;
    
    if (content == null) {
      return 'What would you like me to remind you about?';
    }
    
    return 'I\'ll set a reminder for: $content${when != null ? ' $when' : ''}';
  }

  /// Handle set alarm
  String _handleSetAlarm(Map<String, dynamic> params) {
    final hour = params['hour'] as int?;
    final minute = params['minute'] as int?;
    
    if (hour == null || minute == null) {
      return 'What time would you like to set the alarm?';
    }
    
    final period = params['period'] as String? ?? '';
    return 'Setting alarm for $hour:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Handle create note
  String _handleCreateNote(Map<String, dynamic> params) {
    final content = params['content'] as String?;
    
    if (content == null || content.isEmpty) {
      return 'What would you like me to write in the note?';
    }
    
    return 'I\'ve created a note: "$content"';
  }

  /// Handle calculate
  String _handleCalculate(Map<String, dynamic> params) {
    final expression = params['expression'] as String?;
    
    if (expression == null || expression.isEmpty) {
      return 'What would you like me to calculate?';
    }
    
    // Simple calculation (in production, use math_expressions package)
    try {
      // Basic evaluation
      return 'Opening calculator for: $expression';
    } catch (e) {
      return 'I can help with calculations. Opening calculator...';
    }
  }

  /// Handle translate
  String _handleTranslate(Map<String, dynamic> params) {
    final text = params['text'] as String?;
    final targetLang = params['targetLang'] as String?;
    
    if (text == null) {
      return 'What would you like me to translate?';
    }
    
    if (targetLang == null) {
      return 'Which language would you like me to translate to?';
    }
    
    return 'Opening translator to translate "$text" to $targetLang...';
  }

  /// Handle search contact
  String _handleSearchContact(Map<String, dynamic> params) {
    final name = params['name'] as String?;
    
    if (name == null) {
      return 'Which contact are you looking for?';
    }
    
    return 'Searching for contact: $name';
  }

  /// Stream text word by word
  Stream<String> _streamText(String text) async* {
    final words = text.split(' ');
    String accumulated = '';
    
    for (final word in words) {
      accumulated += (accumulated.isEmpty ? '' : ' ') + word;
      yield accumulated;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Clear conversation history
  void clearHistory() {
    _runAnywhere.clearHistory();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _runAnywhere.dispose();
    _isInitialized = false;
  }
}
