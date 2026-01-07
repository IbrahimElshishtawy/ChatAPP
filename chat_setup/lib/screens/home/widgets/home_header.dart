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
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              blurRadius: 24,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Bar
            Row(
              children: [
                Image.asset(
                  'assets/image/chat-app-icon-24.jpg',
                  width: 26,
                  height: 26,
                ),
                const SizedBox(width: 8),

                ///هنا الإصلاح الأساسي
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: searchMode
                        ? _searchBar(isDark)
                        : Obx(() {
                            final name = userCtrl.user.value?.name ?? 'صديقنا';
                            return Text(
                              name,
                              key: const ValueKey('username'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade700,
                              ),
                            );
                          }),
                  ),
                ),

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

            const SizedBox(height: 6),

            /// 🔹 Description / Subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: searchMode
                  ? const SizedBox.shrink()
                  : Center(
                      child: Obx(() {
                        final desc =
                            userCtrl.user.value?.description ??
                            'ما من وصف لي المستخدم';
                        return Text(
                          desc,
                          key: const ValueKey('description'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 111, 107, 107),
                          ),
                        );
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Search Bar (مصَحَّح)
  Widget _searchBar(bool isDark) {
    return SizedBox(
      height: 42, // 👈 مهم جدًا
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
          filled: true,
          fillColor: isDark ? Colors.grey.shade900 : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
