import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';

class ChatInputBar extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatInputBar({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController textCtrl = TextEditingController();
  bool hasText = false;

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ➕ Attach
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () {
                // TODO: attachments
              },
            ),

            /// 📝 Text Field
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    /// 😊 Emoji
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),

                    /// Input
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (value) {
                          final typing = value.trim().isNotEmpty;
                          if (typing != hasText) {
                            setState(() => hasText = typing);
                          }

                          if (typing) {
                            chatCtrl.startTyping(widget.otherUserId);
                          } else {
                            chatCtrl.stopTyping();
                          }
                        },
                        onTapOutside: (_) => chatCtrl.stopTyping(),
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    /// 📎 Camera / Gallery (اختياري)
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 6),

            /// 🎤 / ✈️ Send
            GestureDetector(
              onTap: () async {
                if (!hasText) {
                  // TODO: Voice record
                  return;
                }

                final text = textCtrl.text.trim();
                if (text.isEmpty) return;

                await chatCtrl.sendMessage(
                  chatId: widget.chatId,
                  text: text,
                  members: [chatCtrl.uid!, widget.otherUserId],
                );

                textCtrl.clear();
                setState(() => hasText = false);
                await chatCtrl.stopTyping();
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF008069), // WhatsApp green
                child: Icon(
                  hasText ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
