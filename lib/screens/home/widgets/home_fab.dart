import 'package:chat/screens/home/new_chat_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 110,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: FloatingActionButton.extended(
          heroTag: 'new_chat',
          elevation: 12,
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(
            Icons.chat_bubble,
            color: Color.fromARGB(241, 251, 248, 248),
          ),
          label: const Text(
            'الاصدقاء',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(249, 250, 248, 248),
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color.fromARGB(0, 86, 105, 225),
              builder: (_) => const NewChatSheet(),
            );
          },
        ),
      ),
    );
  }
}
