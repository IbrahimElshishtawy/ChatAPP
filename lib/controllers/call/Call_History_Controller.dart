// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/call_service.dart';
import '../../core/models/call_model.dart';

class CallHistoryController extends GetxController {
  final CallService _service = CallService();

  final RxList<CallModel> calls = <CallModel>[].obs;

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    calls.bindStream(_service.callHistory(currentUserId));
  }

  bool isOutgoing(CallModel call) => call.callerId == currentUserId;

  bool isMissed(CallModel call) =>
      call.status == CallStatus.missed && call.receiverId == currentUserId;
}
