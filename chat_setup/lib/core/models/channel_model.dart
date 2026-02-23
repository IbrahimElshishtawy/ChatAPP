import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final List<String> admins;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChannelModel({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.admins,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'admins': admins,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory ChannelModel.fromMap(String id, Map<String, dynamic> map) {
    return ChannelModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'],
      ownerId: map['ownerId'] ?? '',
      admins: List<String>.from(map['admins'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }
}
