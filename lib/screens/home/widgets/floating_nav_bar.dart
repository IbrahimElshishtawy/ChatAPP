import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation/navigation_controller.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Obx(() {
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _item(Icons.chat, 0, 'Chats'),
                  _item(Icons.group, 1, 'Groups'),
                  _item(Icons.public, 2, 'Community'),
                  _item(Icons.notifications, 3, 'Alerts'),
                  _item(Icons.person, 4, 'Profile'),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _item(IconData icon, int i, String label) {
    final nav = Get.find<NavigationController>();

    return Obx(() {
      final selected = nav.index.value == i;

      return GestureDetector(
        onTap: () => nav.change(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 18 : 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              AnimatedScale(
                scale: selected ? 1.2 : 1,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  icon,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
