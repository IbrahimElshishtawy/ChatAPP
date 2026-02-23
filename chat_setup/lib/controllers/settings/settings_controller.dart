import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  RxBool notificationsEnabled = true.obs;
  RxBool callNotificationsEnabled = true.obs;
  RxBool groupNotificationsEnabled = true.obs;
  RxBool channelNotificationsEnabled = true.obs;

  static const _notifKey = 'notifications';
  static const _callNotifKey = 'call_notifications';
  static const _groupNotifKey = 'group_notifications';
  static const _channelNotifKey = 'channel_notifications';

  @override
  void onInit() {
    loadSettings();
    super.onInit();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled.value = prefs.getBool(_notifKey) ?? true;
    callNotificationsEnabled.value = prefs.getBool(_callNotifKey) ?? true;
    groupNotificationsEnabled.value = prefs.getBool(_groupNotifKey) ?? true;
    channelNotificationsEnabled.value = prefs.getBool(_channelNotifKey) ?? true;
  }

  Future<void> _syncSettingsWithFirestore() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'settings': {
        'notifications': notificationsEnabled.value,
        'callNotifications': callNotificationsEnabled.value,
        'groupNotifications': groupNotificationsEnabled.value,
        'channelNotifications': channelNotificationsEnabled.value,
      }
    }, SetOptions(merge: true));
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, value);
    await _syncSettingsWithFirestore();
  }

  Future<void> toggleCallNotifications(bool value) async {
    callNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_callNotifKey, value);
    await _syncSettingsWithFirestore();
  }

  Future<void> toggleGroupNotifications(bool value) async {
    groupNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_groupNotifKey, value);
    await _syncSettingsWithFirestore();
  }

  Future<void> toggleChannelNotifications(bool value) async {
    channelNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_channelNotifKey, value);
    await _syncSettingsWithFirestore();
  }
}
