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
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text(
            'شات جديد',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const NewChatSheet(),
            );
          },
        ),
      ),
    );
  }
}
