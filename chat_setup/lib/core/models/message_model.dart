import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;

  final bool isSeen;
  final DateTime? seenAt;

  /// تعديل
  final bool isEdited;
  final DateTime? editedAt;

  /// ↩ رد
  final String? replyToMessageId;
  final String? replyToText;

  ///  React
  final Map<String, String>? reactions;
  // userId : emoji

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.isSeen,
    this.seenAt,
    this.isEdited = false,
    this.editedAt,
    this.replyToMessageId,
    this.replyToText,
    this.reactions,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'isSeen': isSeen,
      'seenAt': seenAt,
      'isEdited': isEdited,
      'editedAt': editedAt,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
      'reactions': reactions ?? {},
    };
  }

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isSeen: map['isSeen'] ?? false,
      seenAt: map['seenAt'] != null
          ? (map['seenAt'] as Timestamp).toDate()
          : null,
      isEdited: map['isEdited'] ?? false,
      editedAt: map['editedAt'] != null
          ? (map['editedAt'] as Timestamp).toDate()
          : null,
      replyToMessageId: map['replyToMessageId'],
      replyToText: map['replyToText'],
      reactions: Map<String, String>.from(map['reactions'] ?? {}),
    );
  }
}
