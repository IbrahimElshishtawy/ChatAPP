import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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

  final _picker = ImagePicker();

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
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () async {
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  final ref = FirebaseStorage.instance.ref().child(
                    'chat_images/${pickedFile.name}',
                  );
                  await ref.putFile(file);
                  final downloadUrl = await ref.getDownloadURL();
                  if (kDebugMode) {
                    print("File uploaded: $downloadUrl");
                  }
                }
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
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
                radius: 22,
                backgroundColor: const Color.fromARGB(255, 0, 128, 64),
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
