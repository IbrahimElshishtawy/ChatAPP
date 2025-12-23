import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'لا يوجد حساب بهذا البريد الإلكتروني',
        );
      }
      if (e.code == 'user-disabled') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'تم تعطيل هذا الحساب',
        );
      }
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'حدث خطأ أثناء تسجيل الدخول',
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(cred.user!.uid).set({
      ...userData,
      'uid': cred.user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
