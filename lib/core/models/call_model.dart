import 'package:cloud_firestore/cloud_firestore.dart';

enum CallType { voice, video }

enum CallStatus { ringing, accepted, rejected, ended }

class CallModel {
  final String callId;
  final String callerId;
  final String receiverId;
  final CallType type;
  final CallStatus status;
  final DateTime createdAt;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'receiverId': receiverId,
      'type': type.name, // voice / video
      'status': status.name, // ringing / accepted ...
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'],
      callerId: map['callerId'],
      receiverId: map['receiverId'],
      type: CallType.values.byName(map['type']),
      status: CallStatus.values.byName(map['status']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
