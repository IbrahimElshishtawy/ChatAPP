import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';

class ChatInputBar extends StatefulWidget {
  final String chatId;
  final List<String> members;

  const ChatInputBar({super.key, required this.chatId, required this.members});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final ctrl = TextEditingController();
  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 📝 Text Field
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: ctrl,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (v) {
                    setState(() => hasText = v.trim().isNotEmpty);
                  },
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالة...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 🚀 Send Button
            AnimatedScale(
              scale: hasText ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: FloatingActionButton(
                mini: true,
                elevation: 2,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.send),
                onPressed: hasText
                    ? () async {
                        final text = ctrl.text.trim();
                        ctrl.clear();
                        setState(() => hasText = false);

                        await chatCtrl.sendMessage(
                          chatId: widget.chatId,
                          text: text,
                          members: widget.members,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
