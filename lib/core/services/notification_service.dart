import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void>? _initFuture;
  StreamSubscription<String>? _tokenSub;

  Future<void> initAndSaveToken() {
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  Future<void> _initInternal() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // token
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(uid, token);
    }

    await _tokenSub?.cancel();
    _tokenSub = _messaging.onTokenRefresh.listen((newToken) async {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) return;
      await _saveToken(currentUid, newToken);
    });
  }

  Future<void> _saveToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).set({
      'fcmToken': token,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> reset() async {
    _initFuture = null;
    await _tokenSub?.cancel();
    _tokenSub = null;
  }
}
