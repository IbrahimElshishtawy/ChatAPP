// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user/user_controller.dart';
import 'quick_settings_sheet.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool searchMode = false;
  final searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();

    return SafeArea(
      bottom: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 Top Bar
            Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/image/chat-app-icon-24.jpg',
                      width: 26, // تغيير الحجم هنا
                      height: 26,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const Spacer(),

                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() => searchMode = true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) => const QuickSettingsSheet(),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// 👤 Username
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: searchMode
                  ? _searchBar()
                  : Obx(() {
                      final name = userCtrl.user.value?.name ?? 'صديقنا';
                      return Text(
                        name,
                        key: const ValueKey('username'),
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.grey.shade700,
                        ),
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      key: const ValueKey('search'),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
        ],
      ),
      child: TextField(
        controller: searchCtrl,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'ابحث عن محادثة...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                searchMode = false;
                searchCtrl.clear();
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
