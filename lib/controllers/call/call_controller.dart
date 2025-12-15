import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../core/models/call_model.dart';
import '../../core/services/call_service.dart';

class CallController extends GetxController {
  final CallService _service = CallService();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Rx<CallModel?> incomingCall = Rx<CallModel?>(null);
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _listenIncomingCalls();
  }

  void _listenIncomingCalls() {
    _sub?.cancel();
    _sub = _service.listenIncomingCalls(_uid).listen((QuerySnapshot snap) {
      if (snap.docs.isEmpty) {
        incomingCall.value = null;
        return;
      }

      final doc = snap.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      incomingCall.value = CallModel.fromMap(data);
    });
  }

  Future<void> acceptCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.accepted);
  }

  Future<void> rejectCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.rejected);
    incomingCall.value = null;
  }

  Future<void> endCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.ended);
    incomingCall.value = null;
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
