enum CallType { voice, video }

enum CallStatus { ringing, accepted, rejected, ended }

class CallModel {
  final String callId;
  final String callerId;
  final String receiverId;
  final CallType type;
  final CallStatus status;
  final String channelName;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.channelName,
  });

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'],
      callerId: map['callerId'],
      receiverId: map['receiverId'],
      channelName: map['channelName'],
      type: CallType.values.byName(map['type']),
      status: CallStatus.values.byName(map['status']),
    );
  }
}
