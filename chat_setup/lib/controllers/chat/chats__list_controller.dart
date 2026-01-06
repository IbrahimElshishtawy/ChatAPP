import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatItem {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? lastMessage;

  ChatItem({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.lastMessage,
  });
}

class ChatsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<ChatItem> chats = <ChatItem>[].obs;

  String? get uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _listenToChats();
  }

  void _listenToChats() {
    final myId = uid;
    if (myId == null) return;

    _firestore
        .collection('chats')
        .where('members', arrayContains: myId)
        .snapshots()
        .listen((snapshot) async {
          final List<ChatItem> items = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final members = List<String>.from(data['members'] ?? []);
            final otherUserId = members.firstWhere((id) => id != myId);

            // اسم الطرف الآخر (مبسّط – تقدر تحسنه لاحقًا)
            final userDoc = await _firestore
                .collection('users')
                .doc(otherUserId)
                .get();

            items.add(
              ChatItem(
                id: doc.id,
                otherUserId: otherUserId,
                otherUserName: userDoc.data()?['name'] ?? 'مستخدم',
                lastMessage: data['lastMessage'],
              ),
            );
          }

          chats.value = items;
        });
  }
}
