// chat message

import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String role; // 'user' or 'bot'
  
  @HiveField(2)
  final String content;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final bool isVoice;
  
  @HiveField(5)
  final bool isFavorite;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isVoice = false,
    this.isFavorite = false,
  });

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    bool? isVoice,
    bool? isFavorite,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isVoice: isVoice ?? this.isVoice,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isVoice': isVoice,
      'isFavorite': isFavorite,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isVoice: json['isVoice'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  bool get isUser => role == 'user';
  bool get isBot => role == 'bot';
}
