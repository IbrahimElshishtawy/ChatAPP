import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> initAndSaveToken() async {
    await _fcm.requestPermission();
    final token = await _fcm.getToken();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && token != null) {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    }
  }
}
