import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _groups => _firestore.collection('groups');

  Future<void> createGroup(GroupModel group) async {
    await _groups.doc(group.id).set(group.toMap());
  }

  Future<void> addMember(String groupId, String userId) async {
    await _groups.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _groups.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> updateMemberRole(String groupId, String userId, String role) async {
    await _groups.doc(groupId).update({
      'roles.$userId': role,
    });
  }

  Future<void> sendGroupMessage({
    required String groupId,
    required MessageModel message,
  }) async {
    final groupRef = _groups.doc(groupId);
    await groupRef.update({
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    });
    await groupRef.collection('messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _groups
        .doc(groupId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
