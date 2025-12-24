// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/call_service.dart';
import '../../../core/models/call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String otherUserId;

  const ChatAppBar({super.key, required this.name, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          const CircleAvatar(radius: 18, child: Icon(Icons.person)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'متصل الآن',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () async {
            final callId = DateTime.now().millisecondsSinceEpoch.toString();

            await Get.find<CallService>().startCall(
              CallModel(
                callId: callId,
                callerId: myId,
                receiverId: otherUserId,
                channelName: callId,
                type: CallType.video,
                status: CallStatus.ringing,
                createdAt: DateTime.now(),
              ),
            );
          },
        ),
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        PopupMenuButton(
          itemBuilder: (_) => const [
            PopupMenuItem(child: Text('معلومات الشات')),
            PopupMenuItem(child: Text('حذف الشات')),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
