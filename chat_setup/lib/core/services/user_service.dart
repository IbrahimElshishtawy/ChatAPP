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
    // التحقق من أن الإيميل أو الرقم ليس مكررًا قبل التحديث
    if (user.email != null) {
      final emailExists = await _users
          .where('email', isEqualTo: user.email)
          .where(FieldPath.documentId, isNotEqualTo: user.id)
          .get();
      if (emailExists.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }
    }

    if (user.phone != null) {
      final phoneExists = await _users
          .where('phone', isEqualTo: user.phone)
          .where(FieldPath.documentId, isNotEqualTo: user.id)
          .get();
      if (phoneExists.docs.isNotEmpty) {
        throw Exception('Phone number already exists');
      }
    }

    await _users.doc(user.id).update(user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();

    // إرجاع المستخدمين الذين لم يتم حذفهم فقط
    return snap.docs
        .where(
          (d) => d.data().containsKey('email') && d.data().containsKey('phone'),
        ) // التأكد من وجود الإيميل والرقم
        .map((d) => UserModel.fromMap(d.id, d.data()))
        .toList();
  }
}
