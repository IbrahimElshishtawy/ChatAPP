import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../core/services/call_service.dart';
import '../../core/models/call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ChatController>();
    final chatId = ctrl.openChat(otherUserId);
    final textCtrl = TextEditingController();

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () async {
              final callId = DateTime.now().millisecondsSinceEpoch.toString();

              await Get.find<CallService>().startCall(
                CallModel(
                  callId: callId,
                  callerId: currentUserId,
                  receiverId: otherUserId,
                  channelName: callId,
                  type: CallType.video,
                  status: CallStatus.ringing,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ctrl.getMessagesStream(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                ctrl.markSeen(chatId);

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data();
                    final isMe = data['senderId'] == ctrl.currentUserId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data['text'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textCtrl,
                  decoration: const InputDecoration(hintText: 'اكتب رسالة...'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (textCtrl.text.trim().isEmpty) return;
                  ctrl.send(chatId, textCtrl.text.trim(), [
                    ctrl.currentUserId,
                    otherUserId,
                  ]);
                  textCtrl.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
