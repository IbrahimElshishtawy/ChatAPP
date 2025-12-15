import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isSeen;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromDoc(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      senderId: map['senderId'],
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isSeen: map['isSeen'] ?? false,
    );
  }
}
