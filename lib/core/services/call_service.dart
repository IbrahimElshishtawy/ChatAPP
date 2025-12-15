import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_model.dart';

class CallService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference calls() => _firestore.collection('calls');

  Future<void> startCall(CallModel call) async {
    await calls().doc(call.callId).set({
      'callId': call.callId,
      'callerId': call.callerId,
      'receiverId': call.receiverId,
      'channelName': call.channelName,
      'type': call.type.name,
      'status': call.status.name,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listenIncomingCalls(String uid) {
    return calls()
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: CallStatus.ringing.name)
        .snapshots();
  }

  Future<void> updateCallStatus(String callId, CallStatus status) async {
    await calls().doc(callId).update({'status': status.name});
  }
}
