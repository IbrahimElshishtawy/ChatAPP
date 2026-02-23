import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String receiverId;
  final DateTime createdAt;
  final String messageType; // text, image, video, audio, file
  final String? fileUrl;
  final String? forwardedFromId;

  final bool isSeen;
  final DateTime? seenAt;

  /// تعديل
  final bool isEdited;
  final DateTime? editedAt;
  final int editCount;
  final DateTime? canEditUntil;

  final bool isDeleted;

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
    this.senderName = '',
    required this.receiverId,
    required this.createdAt,
    this.messageType = 'text',
    this.fileUrl,
    this.forwardedFromId,
    required this.isSeen,
    this.seenAt,
    this.isEdited = false,
    this.editedAt,
    this.editCount = 0,
    this.canEditUntil,
    this.isDeleted = false,
    this.replyToMessageId,
    this.replyToText,
    this.reactions,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'forwardedFromId': forwardedFromId,
      'isSeen': isSeen,
      'seenAt': seenAt,
      'isEdited': isEdited,
      'editedAt': editedAt,
      'editCount': editCount,
      'canEditUntil': canEditUntil,
      'isDeleted': isDeleted,
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
      senderName: map['senderName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      messageType: map['messageType'] ?? 'text',
      fileUrl: map['fileUrl'],
      forwardedFromId: map['forwardedFromId'],
      isSeen: map['isSeen'] ?? false,
      seenAt: map['seenAt'] != null
          ? (map['seenAt'] as Timestamp).toDate()
          : null,
      isEdited: map['isEdited'] ?? false,
      editedAt: map['editedAt'] != null
          ? (map['editedAt'] as Timestamp).toDate()
          : null,
      editCount: map['editCount'] ?? 0,
      canEditUntil: map['canEditUntil'] != null
          ? (map['canEditUntil'] as Timestamp).toDate()
          : null,
      isDeleted: map['isDeleted'] ?? false,
      replyToMessageId: map['replyToMessageId'],
      replyToText: map['replyToText'],
      reactions: Map<String, String>.from(map['reactions'] ?? {}),
    );
  }
}
