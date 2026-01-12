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
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Bar
            Row(
              children: [
                /// Logo
                SizedBox(
                  width: 55,
                  height: 70, // زودنا الارتفاع عشان الكلمة تحت الأيقونة
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 4),
                      const FittedBox(
                        child: Text(
                          'Sawa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 9),

                /// Title / Search
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: searchMode
                        ? _searchBar(isDark)
                        : Obx(() {
                            final name =
                                userCtrl.user.value?.name ?? 'Sawa Chat';
                            return Text(
                              name,
                              key: const ValueKey('username'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                color: isDark
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                            );
                          }),
                  ),
                ),

                /// Search button
                _iconBtn(
                  icon: Icons.search,
                  onTap: () => setState(() => searchMode = true),
                ),

                /// Menu button
                _iconBtn(
                  icon: Icons.more_vert,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: isDark
                          ? Colors.grey.shade900
                          : Colors.white,
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

            const SizedBox(height: 8),

            /// 🔹 Subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: searchMode
                  ? const SizedBox.shrink()
                  : Center(
                      child: Obx(() {
                        final desc =
                            userCtrl.user.value?.description ??
                            'Hello everyone! I am using Sawa Chat.';
                        return Text(
                          desc,
                          key: const ValueKey('description'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade600,
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

  /// 🔹 Search Bar
  Widget _searchBar(bool isDark) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: searchCtrl,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'ابحث عن محادثة...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              setState(() {
                searchMode = false;
                searchCtrl.clear();
              });
            },
          ),
          filled: true,
          fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// 🔹 Icon Button Style
  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      splashRadius: 22,
      icon: Icon(icon, size: 22),
      onPressed: onTap,
    );
  }
}
