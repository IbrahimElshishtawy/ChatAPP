import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 110, // فوق الـ FloatingNavBar
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: FloatingActionButton.extended(
          heroTag: 'new_chat',
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.chat),
          label: const Text(
            'شات جديد',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Get.snackbar('قريبًا', 'بدء شات جديد');
          },
        ),
      ),
    );
  }
}
