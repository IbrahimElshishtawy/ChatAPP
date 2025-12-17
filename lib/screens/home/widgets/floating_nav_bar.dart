import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation/navigation_controller.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    return Obx(() {
      final current = nav.index.value;

      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                icon: Icons.chat,
                index: 0,
                current: current,
                onTap: () => nav.change(0),
              ),
              _item(
                icon: Icons.group,
                index: 1,
                current: current,
                onTap: () => nav.change(1),
              ),
              _item(
                icon: Icons.public,
                index: 2,
                current: current,
                onTap: () => nav.change(2),
              ),
              _item(
                icon: Icons.notifications,
                index: 3,
                current: current,
                onTap: () => nav.change(3),
              ),
              _item(
                icon: Icons.person,
                index: 4,
                current: current,
                onTap: () => nav.change(4),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _item({
    required IconData icon,
    required int index,
    required int current,
    required VoidCallback onTap,
  }) {
    final active = index == current;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 26, color: active ? Colors.blue : Colors.grey),
      ),
    );
  }
}
