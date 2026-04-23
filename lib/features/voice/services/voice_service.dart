import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Voice state
enum VoiceState {
  idle,
  listening,
  processing,
  speaking,
  wakeWordListening,
}

/// Voice Service for BotX
/// Handles Speech-to-Text, Text-to-Speech, and Wake Word Detection
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  // Services
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  
  // State
  VoiceState _state = VoiceState.idle;
  bool _isInitialized = false;
  bool _wakeWordEnabled = false;
  Timer? _wakeWordTimer;
  
  // Callbacks
  Function(String)? onResult;
  Function(VoiceState)? onStateChanged;
  Function(String)? onError;
  
  // Wake word
  static const String wakeWord = 'hey botx';
  static const String wakeWordAlt = 'hey bot';
  
  VoiceState get state => _state;
  bool get isInitialized => _isInitialized;
  bool get wakeWordEnabled => _wakeWordEnabled;

  /// Initialize voice service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        debugPrint('❌ Microphone permission denied');
        return false;
      }
      
      // Initialize Speech-to-Text
      final speechAvailable = await _speech.initialize(
        onError: (error) {
          debugPrint('❌ STT Error: $error');
          onError?.call(error.errorMsg);
        },
        onStatus: (status) {
          debugPrint('🎤 STT Status: $status');
        },
      );
      
      if (!speechAvailable) {
        debugPrint('❌ Speech recognition not available');
        return false;
      }
      
      // Initialize Text-to-Speech
      await _tts.setLanguage('en-IN');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      
      // Set TTS callbacks
      _tts.setStartHandler(() {
        _updateState(VoiceState.speaking);
      });
      
      _tts.setCompletionHandler(() {
        _updateState(VoiceState.idle);
      });
      
      _tts.setErrorHandler((msg) {
        debugPrint('❌ TTS Error: $msg');
        onError?.call(msg);
        _updateState(VoiceState.idle);
      });
      
      _isInitialized = true;
      debugPrint('✅ Voice service initialized');
      return true;
    } catch (e) {
      debugPrint('❌ Voice service initialization error: $e');
      return false;
    }
  }

  /// Start listening for voice input
  Future<void> startListening() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_state == VoiceState.listening) return;
    
    try {
      _updateState(VoiceState.listening);
      
      await _speech.listen(
        onResult: (result) {
          final text = result.recognizedWords;
          debugPrint('🎤 Recognized: $text');
          
          if (result.finalResult) {
            onResult?.call(text);
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_IN',
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('❌ Error starting listening: $e');
      onError?.call(e.toString());
      _updateState(VoiceState.idle);
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_state != VoiceState.listening) return;
    
    try {
      await _speech.stop();
      _updateState(VoiceState.idle);
    } catch (e) {
      debugPrint('❌ Error stopping listening: $e');
    }
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      _updateState(VoiceState.speaking);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('❌ Error speaking: $e');
      onError?.call(e.toString());
      _updateState(VoiceState.idle);
    }
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
      _updateState(VoiceState.idle);
    } catch (e) {
      debugPrint('❌ Error stopping speech: $e');
    }
  }

  /// Enable wake word detection
  Future<void> enableWakeWord() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_wakeWordEnabled) return;
    
    _wakeWordEnabled = true;
    _startWakeWordDetection();
    debugPrint('✅ Wake word enabled');
  }

  /// Disable wake word detection
  void disableWakeWord() {
    _wakeWordEnabled = false;
    _wakeWordTimer?.cancel();
    _wakeWordTimer = null;
    
    if (_state == VoiceState.wakeWordListening) {
      stopListening();
    }
    
    debugPrint('🔇 Wake word disabled');
  }

  /// Start wake word detection
  void _startWakeWordDetection() {
    if (!_wakeWordEnabled) return;
    
    _wakeWordTimer?.cancel();
    _wakeWordTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_wakeWordEnabled || _state != VoiceState.idle) return;
      
      try {
        _updateState(VoiceState.wakeWordListening);
        
        await _speech.listen(
          onResult: (result) {
            final text = result.recognizedWords.toLowerCase();
            debugPrint('🎤 Wake word check: $text');
            
            if (text.contains(wakeWord) || text.contains(wakeWordAlt)) {
              debugPrint('✅ Wake word detected!');
              _speech.stop();
              _onWakeWordDetected();
            }
          },
          listenFor: const Duration(seconds: 3),
          pauseFor: const Duration(seconds: 1),
          partialResults: true,
          localeId: 'en_IN',
        );
        
        // Return to idle after listening
        await Future.delayed(const Duration(seconds: 3));
        if (_state == VoiceState.wakeWordListening) {
          _updateState(VoiceState.idle);
        }
      } catch (e) {
        debugPrint('❌ Wake word detection error: $e');
        _updateState(VoiceState.idle);
      }
    });
  }

  /// Handle wake word detection
  void _onWakeWordDetected() {
    // Play confirmation sound or speak
    speak('Yes?');
    
    // Start listening for command
    Future.delayed(const Duration(milliseconds: 500), () {
      startListening();
    });
  }

  /// Update state and notify listeners
  void _updateState(VoiceState newState) {
    if (_state == newState) return;
    
    _state = newState;
    onStateChanged?.call(_state);
    debugPrint('🔄 Voice state: $newState');
  }

  /// Set speech rate (0.0 - 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate.clamp(0.1, 1.0));
  }

  /// Set speech pitch (0.5 - 2.0)
  Future<void> setSpeechPitch(double pitch) async {
    await _tts.setPitch(pitch.clamp(0.5, 2.0));
  }

  /// Get available languages
  Future<List<String>> getLanguages() async {
    try {
      final languages = await _tts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      debugPrint('❌ Error getting languages: $e');
      return [];
    }
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    try {
      await _tts.setLanguage(language);
    } catch (e) {
      debugPrint('❌ Error setting language: $e');
    }
  }

  /// Check if speech recognition is available
  Future<bool> isSpeechAvailable() async {
    return await _speech.initialize();
  }

  /// Get available locales for speech recognition
  Future<List<String>> getLocales() async {
    try {
      final locales = await _speech.locales();
      return locales.map((locale) => locale.localeId).toList();
    } catch (e) {
      debugPrint('❌ Error getting locales: $e');
      return [];
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    disableWakeWord();
    await stopListening();
    await stopSpeaking();
    _isInitialized = false;
  }
}
