import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? nickname;
  final String? description;
  final String? websiteLink;
  final String? phone;
  final String role;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
  final String backgroundImage;
  final String? username;
  final String? profilePicture;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  final String plan;
  final DateTime? planExpiry;

  final List<String> blockedUsers;
  final List<String> blockedCalls;
  final List<String> blockedGroups;
  final Map<String, dynamic> privacySettings;

  UserModel({
    required this.profilePicture,
    required this.id,
    required this.name,
    this.email,
    this.nickname,
    this.description,
    this.websiteLink,
    this.phone,
    required this.role,
    this.username,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.whatsapp,
    required this.backgroundImage,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.plan = 'free',
    this.planExpiry,
    this.blockedUsers = const [],
    this.blockedCalls = const [],
    this.blockedGroups = const [],
    this.privacySettings = const {},
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      nickname: map['nickname'],
      phone: map['phone'],
      description: map['description'],
      websiteLink: map['websiteLink'],
      role: map['role'] ?? 'user',
      username: map['username'],
      profilePicture: map['profilePicture'],
      backgroundImage: map['backgroundImage'] ?? '',
      postsCount: map['postsCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      plan: map['plan'] ?? 'free',
      planExpiry: map['planExpiry'] != null
          ? (map['planExpiry'] as Timestamp).toDate()
          : null,
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      blockedCalls: List<String>.from(map['blockedCalls'] ?? []),
      blockedGroups: List<String>.from(map['blockedGroups'] ?? []),
      privacySettings: Map<String, dynamic>.from(map['privacySettings'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'nickname': nickname,
      'phone': phone,
      'role': role,
      'description': description,
      'websiteLink': websiteLink,
      'username': username,
      'profilePicture': profilePicture,
      'backgroundImage': backgroundImage,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'plan': plan,
      'planExpiry': planExpiry,
      'blockedUsers': blockedUsers,
      'blockedCalls': blockedCalls,
      'blockedGroups': blockedGroups,
      'privacySettings': privacySettings,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? nickname,
    String? phone,
    String? role,
    String? username,
    String? profilePicture,
    String? linkedin,
    String? facebook,
    String? description,
    String? websiteLink,
    String? instagram,
    String? whatsapp,
    String? backgroundImage,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    String? plan,
    DateTime? planExpiry,
    List<String>? blockedUsers,
    List<String>? blockedCalls,
    List<String>? blockedGroups,
    Map<String, dynamic>? privacySettings,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      description: description ?? this.description,
      websiteLink: websiteLink ?? this.websiteLink,
      profilePicture: profilePicture ?? this.profilePicture,
      username: username ?? this.username,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      plan: plan ?? this.plan,
      planExpiry: planExpiry ?? this.planExpiry,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedCalls: blockedCalls ?? this.blockedCalls,
      blockedGroups: blockedGroups ?? this.blockedGroups,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
}
