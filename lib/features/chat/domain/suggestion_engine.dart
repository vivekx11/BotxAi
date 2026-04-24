// suggesting dart 

import 'dart:math';

class SuggestionEngine {
  SuggestionEngine._();
  
  static final List<String> _generalSuggestions = [
    'What\'s the weather?',
    'What time is it?',
    'Tell me a joke',
    'Open Instagram',
    'Calculate 25 * 4',
    'Set a reminder',
    'Translate hello to Spanish',
    'What\'s my battery level?',
    'Open YouTube',
    'What day is it?',
  ];
  
  static final Map<String, List<String>> _contextualSuggestions = {
    'weather': [
      'Show 5-day forecast',
      'Weather in another city',
      'Will it rain today?',
    ],
    'time': [
      'Set an alarm',
      'What\'s the date?',
      'Set a timer',
    ],
    'app': [
      'Open WhatsApp',
      'Open Maps',
      'Open Camera',
    ],
    'calculate': [
      'Calculate 15% of 200',
      'Open calculator',
      'Convert 100 USD to EUR',
    ],
    'translate': [
      'Translate to Hindi',
      'Open translator',
      'How do you say thank you in French?',
    ],
    'battery': [
      'Is my phone charging?',
      'Battery percentage',
      'Power saving tips',
    ],
  ];
  
  static List<String> generateSuggestions({
    String? lastBotMessage,
    String? lastUserMessage,
  }) {
    // If we have context, provide contextual suggestions
    if (lastBotMessage != null) {
      final lowerMessage = lastBotMessage.toLowerCase();
      
      for (final entry in _contextualSuggestions.entries) {
        if (lowerMessage.contains(entry.key)) {
          return entry.value.take(3).toList();
        }
      }
    }
    
    // Otherwise, return random general suggestions
    final shuffled = List<String>.from(_generalSuggestions)..shuffle(Random());
    return shuffled.take(3).toList();
  }
  
  static List<String> getQuickActions() {
    return [
      'Weather',
      'Calculator',
      'Notes',
      'Translator',
      'Battery',
      'Time',
    ];
  }
  
  static List<String> getAppSuggestions() {
    return [
      'Open Instagram',
      'Open YouTube',
      'Open WhatsApp',
      'Open Camera',
      'Open Maps',
      'Open Chrome',
    ];
  }
  
  static List<String> getToolSuggestions() {
    return [
      'Open calculator',
      'Create a note',
      'Check weather',
      'Translate text',
      'View contacts',
    ];
  }
}
