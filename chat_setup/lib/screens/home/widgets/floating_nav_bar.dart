// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation/navigation_controller.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // تأمين الكنترولر (يمنع not found)
    final nav = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController());

    return Positioned(
      left: 16,
      right: 16,
      bottom: 14,
      child: Obx(() {
        final index = nav.index.value;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'الدردشات',
                selected: index == 0,
                onTap: () => nav.change(0),
              ),
              _NavItem(
                icon: Icons.group_rounded,
                label: 'الجروبات',
                selected: index == 1,
                onTap: () => nav.change(1),
              ),
              _NavItem(
                icon: Icons.public_rounded,
                label: 'المجتمع',
                selected: index == 2,
                onTap: () => nav.change(2),
              ),
              _NavItem(
                icon: Icons.notifications_rounded,
                label: 'التنبيهات',
                selected: index == 3,
                onTap: () => nav.change(3),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'الملف',
                selected: index == 4,
                onTap: () => nav.change(4),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: selected ? 1.08 : 1.0,
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selected
                      ? primary.withOpacity(0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: selected ? primary : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? primary : Colors.grey.shade600,
                ),
                child: Text(label),
              ),
              const SizedBox(height: 4),

              /// 🔵 Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: selected ? 18 : 0,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
