import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_model.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _calls => _firestore.collection('calls');

  Future<void> createCall(CallModel call) async {
    await _calls.doc(call.callId).set(call.toMap());
  }

  Future<void> updateCallStatus(String callId, CallStatus status) async {
    await _calls.doc(callId).update({'status': status.name});
  }

  Stream<CallModel?> listenToCall(String callId) {
    return _calls.doc(callId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return CallModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Stream<QuerySnapshot> listenIncomingCalls(String userId) {
    return _calls
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: CallStatus.ringing.name)
        .snapshots();
  }
}
