import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> initAndSaveToken() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // طلب صلاحية الإشعارات (Android 13+ و iOS)
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // توكن الجهاز
    final token = await _messaging.getToken();
    if (token == null) return;

    // احفظ التوكن بأمان (set + merge) لتفادي NOT_FOUND
    await _firestore.collection('users').doc(uid).set({
      'fcmToken': token,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // لو التوكن اتغيّر
    _messaging.onTokenRefresh.listen((newToken) async {
      await _firestore.collection('users').doc(uid).set({
        'fcmToken': newToken,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}
