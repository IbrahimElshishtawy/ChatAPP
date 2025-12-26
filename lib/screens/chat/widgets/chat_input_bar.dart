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
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey, size: 24),
              onPressed: () {
                // TODO: Implement Attachments (images, videos, etc.)
              },
            ),

            /// 📝 Text Field with Emojis
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),

                    /// Input Field
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
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// 📎 Camera / Gallery (optional)
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey.shade600,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                if (!hasText) {
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
                radius: 26,
                backgroundColor: hasText
                    ? const Color(0xFF008069)
                    : Colors.grey,
                child: Icon(
                  hasText ? Icons.send : Icons.mic,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
