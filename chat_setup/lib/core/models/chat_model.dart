import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType { direct, group, channel }

class ChatModel {
  final String id;
  final List<String> members;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final ChatType type;
  final Map<String, dynamic> settings; // per-user settings: {uid: {muted: bool, visibility: string, ...}}

  ChatModel({
    required this.id,
    required this.members,
    required this.lastMessage,
    this.lastMessageTime,
    required this.type,
    this.settings = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'type': type.name,
      'settings': settings,
    };
  }

  factory ChatModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatModel(
      id: id,
      members: List<String>.from(map['members'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
      type: ChatType.values.byName(map['type'] ?? 'direct'),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }
}
