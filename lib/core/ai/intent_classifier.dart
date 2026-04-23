// files 
import 'package:flutter/foundation.dart';

/// Intent types that BotX can handle
enum IntentType {
  appLaunch,
  sendMessage,
  makeCall,
  setReminder,
  setAlarm,
  createNote,
  calculate,
  translate,
  searchContact,
  checkBattery,
  checkTime,
  checkDate,
  openSettings,
  generalQuery,
  unknown,
}

/// Intent classification result
class IntentResult {
  final IntentType type;
  final Map<String, dynamic> parameters;
  final double confidence;

  IntentResult({
    required this.type,
    required this.parameters,
    this.confidence = 1.0,
  });
}

/// Advanced Intent Classifier for BotX
/// Analyzes user input and determines the action to take
class IntentClassifier {
  IntentClassifier._();

  /// Classify user input into intent
  static IntentResult classify(String input) {
    final lowerInput = input.toLowerCase().trim();
    
    // App Launch Intent
    if (_isAppLaunchIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.appLaunch,
        parameters: {'app': _extractAppName(lowerInput)},
        confidence: 0.95,
      );
    }
    
    // Send Message Intent
    if (_isSendMessageIntent(lowerInput)) {
      final params = _extractMessageParams(lowerInput);
      return IntentResult(
        type: IntentType.sendMessage,
        parameters: params,
        confidence: 0.9,
      );
    }
    
    // Make Call Intent
    if (_isCallIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.makeCall,
        parameters: {'contact': _extractContactName(lowerInput)},
        confidence: 0.9,
      );
    }
    
    // Set Reminder Intent
    if (_isReminderIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.setReminder,
        parameters: _extractReminderParams(lowerInput),
        confidence: 0.85,
      );
    }
    
    // Set Alarm Intent
    if (_isAlarmIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.setAlarm,
        parameters: _extractAlarmParams(lowerInput),
        confidence: 0.85,
      );
    }
    
    // Create Note Intent
    if (_isNoteIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.createNote,
        parameters: {'content': _extractNoteContent(lowerInput)},
        confidence: 0.8,
      );
    }
    
    // Calculate Intent
    if (_isCalculateIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.calculate,
        parameters: {'expression': _extractCalculation(lowerInput)},
        confidence: 0.9,
      );
    }
    
    // Translate Intent
    if (_isTranslateIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.translate,
        parameters: _extractTranslationParams(lowerInput),
        confidence: 0.85,
      );
    }
    
    // Search Contact Intent
    if (_isContactSearchIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.searchContact,
        parameters: {'name': _extractContactName(lowerInput)},
        confidence: 0.8,
      );
    }
    
    // Check Battery Intent
    if (_isBatteryIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.checkBattery,
        parameters: {},
        confidence: 0.95,
      );
    }
    
    // Check Time Intent
    if (_isTimeIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.checkTime,
        parameters: {},
        confidence: 0.95,
      );
    }
    
    // Check Date Intent
    if (_isDateIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.checkDate,
        parameters: {},
        confidence: 0.95,
      );
    }
    
    // Open Settings Intent
    if (_isSettingsIntent(lowerInput)) {
      return IntentResult(
        type: IntentType.openSettings,
        parameters: {},
        confidence: 0.9,
      );
    }
    
    // General Query (let AI handle it)
    return IntentResult(
      type: IntentType.generalQuery,
      parameters: {'query': input},
      confidence: 0.5,
    );
  }

  // Intent Detection Methods

  static bool _isAppLaunchIntent(String input) {
    return input.contains('open') && 
           _containsAny(input, ['instagram', 'whatsapp', 'youtube', 'camera', 
                                'chrome', 'gmail', 'maps', 'facebook', 'twitter',
                                'spotify', 'netflix', 'telegram', 'snapchat']);
  }

  static bool _isSendMessageIntent(String input) {
    return _containsAny(input, ['send message', 'send msg', 'text', 'whatsapp']) &&
           (_containsAny(input, ['to', 'contact']) || _hasContactName(input));
  }

  static bool _isCallIntent(String input) {
    return _containsAny(input, ['call', 'phone', 'dial']) && _hasContactName(input);
  }

  static bool _isReminderIntent(String input) {
    return _containsAny(input, ['remind', 'reminder', 'remember to']);
  }

  static bool _isAlarmIntent(String input) {
    return _containsAny(input, ['alarm', 'wake me', 'set alarm']);
  }

  static bool _isNoteIntent(String input) {
    return _containsAny(input, ['note', 'write down', 'save this', 'remember this']);
  }

  static bool _isCalculateIntent(String input) {
    return _containsAny(input, ['calculate', 'compute', 'what is']) &&
           (_hasNumbers(input) || _hasMathOperators(input));
  }

  static bool _isTranslateIntent(String input) {
    return _containsAny(input, ['translate', 'translation', 'in hindi', 'in english', 'in marathi']);
  }

  static bool _isContactSearchIntent(String input) {
    return _containsAny(input, ['find contact', 'search contact', 'contact info']);
  }

  static bool _isBatteryIntent(String input) {
    return _containsAny(input, ['battery', 'charge', 'power level']);
  }

  static bool _isTimeIntent(String input) {
    return _containsAny(input, ['time', 'what time', 'current time']);
  }

  static bool _isDateIntent(String input) {
    return _containsAny(input, ['date', 'what date', 'today', 'day']);
  }

  static bool _isSettingsIntent(String input) {
    return input.contains('settings') || input.contains('preferences');
  }

  // Parameter Extraction Methods

  static String _extractAppName(String input) {
    final apps = {
      'instagram': 'instagram',
      'whatsapp': 'whatsapp',
      'youtube': 'youtube',
      'camera': 'camera',
      'chrome': 'chrome',
      'gmail': 'gmail',
      'maps': 'maps',
      'facebook': 'facebook',
      'twitter': 'twitter',
      'x': 'twitter',
      'spotify': 'spotify',
      'netflix': 'netflix',
      'telegram': 'telegram',
      'snapchat': 'snapchat',
    };
    
    for (final entry in apps.entries) {
      if (input.contains(entry.key)) {
        return entry.value;
      }
    }
    return '';
  }

  static Map<String, dynamic> _extractMessageParams(String input) {
    final params = <String, dynamic>{};
    
    // Extract contact name (after "to")
    final toMatch = RegExp(r'to\s+(\w+)').firstMatch(input);
    if (toMatch != null) {
      params['contact'] = toMatch.group(1);
    }
    
    // Extract message content (after "say" or "message")
    final sayMatch = RegExp(r'say\s+(.+)').firstMatch(input);
    if (sayMatch != null) {
      params['message'] = sayMatch.group(1);
    } else {
      final msgMatch = RegExp(r'message\s+(.+)').firstMatch(input);
      if (msgMatch != null) {
        params['message'] = msgMatch.group(1);
      }
    }
    
    return params;
  }

  static String _extractContactName(String input) {
    // Try to extract name after "to", "call", or "contact"
    final patterns = [
      RegExp(r'to\s+(\w+)'),
      RegExp(r'call\s+(\w+)'),
      RegExp(r'contact\s+(\w+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(input);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }
    return '';
  }

  static Map<String, dynamic> _extractReminderParams(String input) {
    final params = <String, dynamic>{};
    
    // Extract reminder content
    final remindMatch = RegExp(r'remind me to\s+(.+)').firstMatch(input);
    if (remindMatch != null) {
      params['content'] = remindMatch.group(1);
    }
    
    // Extract time (basic patterns)
    if (input.contains('tomorrow')) {
      params['when'] = 'tomorrow';
    } else if (input.contains('tonight')) {
      params['when'] = 'tonight';
    } else if (input.contains('morning')) {
      params['when'] = 'morning';
    }
    
    return params;
  }

  static Map<String, dynamic> _extractAlarmParams(String input) {
    final params = <String, dynamic>{};
    
    // Extract time (HH:MM format)
    final timeMatch = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(input);
    if (timeMatch != null) {
      params['hour'] = int.parse(timeMatch.group(1)!);
      params['minute'] = int.parse(timeMatch.group(2)!);
    }
    
    // Check for AM/PM
    if (input.contains('am')) {
      params['period'] = 'AM';
    } else if (input.contains('pm')) {
      params['period'] = 'PM';
    }
    
    return params;
  }

  static String _extractNoteContent(String input) {
    // Extract content after "note", "write down", etc.
    final patterns = [
      RegExp(r'note\s+(.+)'),
      RegExp(r'write down\s+(.+)'),
      RegExp(r'save this\s+(.+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(input);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }
    return input;
  }

  static String _extractCalculation(String input) {
    // Remove "calculate", "what is", etc.
    return input
        .replaceAll('calculate', '')
        .replaceAll('what is', '')
        .replaceAll('compute', '')
        .trim();
  }

  static Map<String, dynamic> _extractTranslationParams(String input) {
    final params = <String, dynamic>{};
    
    // Detect target language
    if (input.contains('hindi')) {
      params['targetLang'] = 'hindi';
    } else if (input.contains('english')) {
      params['targetLang'] = 'english';
    } else if (input.contains('marathi')) {
      params['targetLang'] = 'marathi';
    }
    
    // Extract text to translate
    final translateMatch = RegExp(r'translate\s+(.+?)\s+(?:to|in)').firstMatch(input);
    if (translateMatch != null) {
      params['text'] = translateMatch.group(1);
    }
    
    return params;
  }

  // Helper Methods

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  static bool _hasContactName(String input) {
    // Simple check: contains "to" followed by a word
    return RegExp(r'to\s+\w+').hasMatch(input);
  }

  static bool _hasNumbers(String input) {
    return RegExp(r'\d+').hasMatch(input);
  }

  static bool _hasMathOperators(String input) {
    return _containsAny(input, ['+', '-', '*', '/', 'plus', 'minus', 'times', 'divided']);
  }
}
