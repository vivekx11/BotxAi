import 'package:hive_flutter/hive_flutter.dart';
import '../domain/chat_message.dart';

class ChatRepository {
  static const String _boxName = 'chat_history';
  static const int _maxMessages = 200;
  
  Box<dynamic> get _box => Hive.box(_boxName);
  
  Future<void> saveMessage(ChatMessage message) async {
    final messages = await getMessages();
    messages.add(message);
    
    // Keep only last 200 messages
    if (messages.length > _maxMessages) {
      messages.removeRange(0, messages.length - _maxMessages);
    }
    
    await _box.put('messages', messages.map((m) => m.toJson()).toList());
  }
  
  Future<List<ChatMessage>> getMessages() async {
    final data = _box.get('messages', defaultValue: []) as List;
    return data
        .map((json) => ChatMessage.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
  
  Future<void> deleteMessage(String id) async {
    final messages = await getMessages();
    messages.removeWhere((m) => m.id == id);
    await _box.put('messages', messages.map((m) => m.toJson()).toList());
  }
  
  Future<void> toggleFavorite(String id) async {
    final messages = await getMessages();
    final index = messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        isFavorite: !messages[index].isFavorite,
      );
      await _box.put('messages', messages.map((m) => m.toJson()).toList());
    }
  }
  
  Future<void> clearHistory() async {
    await _box.delete('messages');
  }
  
  Future<List<ChatMessage>> getFavorites() async {
    final messages = await getMessages();
    return messages.where((m) => m.isFavorite).toList();
  }
  
  Future<int> getMessageCount() async {
    final messages = await getMessages();
    return messages.length;
  }
  
  Future<int> getUserMessageCount() async {
    final messages = await getMessages();
    return messages.where((m) => m.isUser).length;
  }
  
  Future<int> getVoiceMessageCount() async {
    final messages = await getMessages();
    return messages.where((m) => m.isVoice).length;
  }
}
