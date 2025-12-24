import 'package:chat/screens/home/new_chat_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 125,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: FloatingActionButton(
          heroTag: 'new_chat',
          elevation: 10,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.chat_rounded, size: 26),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => const NewChatSheet(),
            );
          },
        ),
      ),
    );
  }
}
