import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chat_message.dart';
import '../data/chat_repository.dart';
import 'ai_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository());

final chatMessagesProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
  return ChatNotifier(
    ref.watch(chatRepositoryProvider),
    ref.watch(aiProvider),
  );
});

final isTypingProvider = StateProvider<bool>((ref) => false);

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatRepository _repository;
  final AIService _aiService;
  
  ChatNotifier(this._repository, this._aiService) : super(const AsyncValue.loading()) {
    _loadMessages();
  }
  
  Future<void> _loadMessages() async {
    try {
      final messages = await _repository.getMessages();
      state = AsyncValue.data(messages);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> sendMessage(String content, {bool isVoice = false}) async {
    if (content.trim().isEmpty) return;
    
    try {
      // Add user message
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
        isVoice: isVoice,
      );
      
      await _repository.saveMessage(userMessage);
      await _loadMessages();
      
      // Get AI response
      final response = await _aiService.sendMessage(content);
      
      // Add bot message
      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'bot',
        content: response,
        timestamp: DateTime.now(),
      );
      
      await _repository.saveMessage(botMessage);
      await _loadMessages();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> sendMessageStream(String content, {bool isVoice = false}) async {
    if (content.trim().isEmpty) return;
    
    try {
      // Add user message
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
        isVoice: isVoice,
      );
      
      await _repository.saveMessage(userMessage);
      await _loadMessages();
      
      // Create placeholder bot message
      final botMessageId = DateTime.now().millisecondsSinceEpoch.toString();
      String accumulatedResponse = '';
      
      // Stream AI response
      await for (final chunk in _aiService.sendMessageStream(content)) {
        accumulatedResponse += chunk;
        
        // Update bot message
        final botMessage = ChatMessage(
          id: botMessageId,
          role: 'bot',
          content: accumulatedResponse,
          timestamp: DateTime.now(),
        );
        
        // Update in repository
        await _repository.saveMessage(botMessage);
        await _loadMessages();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> deleteMessage(String id) async {
    await _repository.deleteMessage(id);
    await _loadMessages();
  }
  
  Future<void> toggleFavorite(String id) async {
    await _repository.toggleFavorite(id);
    await _loadMessages();
  }
  
  Future<void> clearHistory() async {
    await _repository.clearHistory();
    _aiService.resetChat();
    state = const AsyncValue.data([]);
  }
  
  Future<void> refresh() async {
    await _loadMessages();
  }
}
