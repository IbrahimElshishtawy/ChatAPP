import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  /// 🔹 Get single user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data()!);
  }

  /// 🔹 UPDATE user
  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.id).update(user.toMap());
  }

  /// 🔥 GET ALL USERS (دي الجديدة)
  Future<List<UserModel>> getAllUsers() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();

    return snap.docs.map((d) => UserModel.fromMap(d.id, d.data())).toList();
  }
}
