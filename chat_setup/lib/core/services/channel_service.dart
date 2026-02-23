import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/channel_model.dart';
import '../models/message_model.dart';

class ChannelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _channels => _firestore.collection('channels');

  Future<void> createChannel(ChannelModel channel) async {
    await _channels.doc(channel.id).set(channel.toMap());
  }

  Stream<List<ChannelModel>> getChannels() {
    return _channels.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ChannelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> sendChannelMessage({
    required String channelId,
    required MessageModel message,
  }) async {
    final channelRef = _channels.doc(channelId);

    await channelRef.update({
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    });

    await channelRef.collection('messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getChannelMessages(String channelId) {
    return _channels
        .doc(channelId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
