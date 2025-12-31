import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesList extends StatelessWidget {
  final String chatId;

  const MessagesList({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return StreamBuilder(
      stream: chatCtrl.getMessages(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        chatCtrl.markSeen(chatId);

        return ListView.builder(
          reverse: true, // لتكون الرسائل الأحدث في الأسفل
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final isMe = data['senderId'] == chatCtrl.uid;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: isMe
                    ? MainAxisAlignment
                          .end // محاذاة الرسائل الخاصة بي
                    : MainAxisAlignment.start, // محاذاة الرسائل الواردة
                children: [
                  // عرض الرسائل مع فقاعة ونص الرسالة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['text'],
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.black87,
                          ),
                        ),
                        // وقت الرسالة
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              _getTimeAgo(data['createdAt']),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // حالة الرسالة (تم التسليم/القراءة)
                            if (isMe)
                              Icon(
                                data['isSeen'] ?? false
                                    ? Icons.check_circle
                                    : Icons.check,
                                size: 16,
                                color: data['isSeen'] ?? false
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // صورة الملف الشخصي إذا كانت الرسالة ليست مني
                  if (!isMe) const SizedBox(width: 8),
                  if (!isMe)
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        data['senderName'][0], // عرض الحرف الأول من الاسم
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // دالة لتحويل الوقت إلى تنسيق قابل للقراءة مثل "منذ 5 دقائق"
  String _getTimeAgo(Timestamp timestamp) {
    final time = timestamp.toDate();
    final difference = DateTime.now().difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ثواني';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعة';
    } else {
      return '${difference.inDays} يوم';
    }
  }
}
