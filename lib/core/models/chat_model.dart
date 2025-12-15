class ChatModel {
  final String chatId;
  final List<String> members;
  final String lastMessage;
  final DateTime? lastMessageTime;

  ChatModel({
    required this.chatId,
    required this.members,
    required this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory ChatModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatModel(
      chatId: id,
      members: List<String>.from(map['members']),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime']?.toDate(),
    );
  }
}
