import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/utils/intent_launcher.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/battery_utils.dart';

final aiProvider = Provider<AIService>((ref) => AIService());

class AIService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with actual key
  late final GenerativeModel _model;
  ChatSession? _chatSession;
  
  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'You are BotX, a helpful, concise, and warm AI assistant. '
        'You help users with everyday tasks, answer questions, and control their phone. '
        'Keep responses brief and friendly. Use emojis occasionally. '
        'When users ask to open apps, confirm the action. '
        'For calculations, provide clear answers. '
        'Be conversational and natural.',
      ),
    );
  }
  
  Future<String> sendMessage(String message) async {
    try {
      // Check for intent patterns first
      final intentResponse = await _handleIntent(message);
      if (intentResponse != null) {
        return intentResponse;
      }
      
      // Use Gemini AI for general queries
      if (_chatSession == null) {
        _chatSession = _model.startChat();
      }
      
      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );
      
      return response.text ?? 'I couldn\'t process that. Please try again.';
    } catch (e) {
      print('AI Error: $e');
      return _getOfflineFallback(message);
    }
  }
  
  Stream<String> sendMessageStream(String message) async* {
    try {
      // Check for intent patterns first
      final intentResponse = await _handleIntent(message);
      if (intentResponse != null) {
        yield intentResponse;
        return;
      }
      
      // Use Gemini AI streaming for general queries
      if (_chatSession == null) {
        _chatSession = _model.startChat();
      }
      
      final response = _chatSession!.sendMessageStream(
        Content.text(message),
      );
      
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      print('AI Stream Error: $e');
      yield _getOfflineFallback(message);
    }
  }
  
  Future<String?> _handleIntent(String message) async {
    final lowerMessage = message.toLowerCase().trim();
    
    // App launch intent
    final appLaunchPattern = RegExp(r'open\s+(\w+)');
    final appMatch = appLaunchPattern.firstMatch(lowerMessage);
    if (appMatch != null) {
      final appName = appMatch.group(1)!;
      return await IntentLauncher.openApp(appName);
    }
    
    // Time/Date intent
    if (lowerMessage.contains('time') || lowerMessage.contains('what time')) {
      return AppDateUtils.respondToTimeQuery();
    }
    if (lowerMessage.contains('date') || lowerMessage.contains('what date') || 
        lowerMessage.contains('today')) {
      return AppDateUtils.respondToDateQuery();
    }
    if (lowerMessage.contains('day') || lowerMessage.contains('what day')) {
      return AppDateUtils.respondToDayQuery();
    }
    
    // Battery intent
    if (lowerMessage.contains('battery') || lowerMessage.contains('charge')) {
      return await BatteryUtils.respondToBatteryQuery();
    }
    
    // Calculator intent (simple)
    final calcPattern = RegExp(r'calculate\s+(.+)');
    final calcMatch = calcPattern.firstMatch(lowerMessage);
    if (calcMatch != null) {
      return 'Opening calculator for you...';
    }
    
    // Weather intent
    if (lowerMessage.contains('weather')) {
      return 'Let me check the weather for you...';
    }
    
    // Translation intent
    if (lowerMessage.contains('translate')) {
      return 'Opening translator for you...';
    }
    
    return null; // No intent matched, use AI
  }
  
  String _getOfflineFallback(String message) {
    final lowerMessage = message.toLowerCase().trim();
    
    // Simple offline responses
    final offlineResponses = {
      'hello': 'Hi there! 👋',
      'hi': 'Hello! How can I help you?',
      'hey': 'Hey! What\'s up?',
      'how are you': 'I\'m doing great! Thanks for asking. 😊',
      'thanks': 'You\'re welcome! 😊',
      'thank you': 'Happy to help! 🙌',
      'bye': 'Goodbye! Have a great day! 👋',
      'help': 'I can help you with:\n• Opening apps\n• Checking time/date\n• Battery status\n• Weather\n• Calculations\n• Translations\n\nJust ask me!',
    };
    
    for (final entry in offlineResponses.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return 'I\'m currently offline. I can still help with basic tasks like opening apps, checking time, and battery status.';
  }
  
  void resetChat() {
    _chatSession = null;
  }
}
