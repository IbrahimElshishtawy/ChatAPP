import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 🔄 Auth state
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// 🔐 LOGIN
  Future<User> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// 📝 REGISTER
  Future<User> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        ...userData,
        'uid': cred.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// 🌐 GOOGLE SIGN IN
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore, if not create
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? '',
            'email': user.email,
            'profilePicture': user.photoURL,
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'user',
            'plan': 'free',
          });
        }
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// ❗ Error Mapper (موحد)
  FirebaseAuthException _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseAuthException(
          code: e.code,
          message: 'لا يوجد حساب بهذا البريد الإلكتروني',
        );
      case 'wrong-password':
      case 'invalid-credential':
        return FirebaseAuthException(
          code: e.code,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      case 'email-already-in-use':
        return FirebaseAuthException(
          code: e.code,
          message: 'البريد الإلكتروني مستخدم بالفعل',
        );
      case 'weak-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'كلمة المرور ضعيفة',
        );
      case 'user-disabled':
        return FirebaseAuthException(
          code: e.code,
          message: 'تم تعطيل هذا الحساب',
        );
      default:
        return FirebaseAuthException(
          code: e.code,
          message: 'حدث خطأ غير متوقع',
        );
    }
  }
}
