import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String text;
  final String senderId;
  final DateTime createdAt;
  final bool isSeen;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.createdAt,
    required this.isSeen,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'createdAt': createdAt,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      senderId: map['senderId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isSeen: map['isSeen'] ?? false,
      id: '${map['id']}',
    );
  }
}
