import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user/user_controller.dart';

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
    final userName = userCtrl.user.value?.name ?? 'صديقنا';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔝 Top Bar
              Row(
                children: [
                  /// App Name
                  const Text(
                    'ChatApp',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),

                  /// 🔍 Search Icon
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() => searchMode = true);
                    },
                  ),

                  /// ⋮ Menu
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'profile') {
                        Get.toNamed('/profile');
                      }
                      if (v == 'logout') {
                        Get.toNamed('/login');
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'profile',
                        child: Text('الملف الشخصي'),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: Text('تسجيل الخروج'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// 👋 Welcome Text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: searchMode
                    ? _searchBar()
                    : Center(
                        child: Row(
                          key: const ValueKey('welcome'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   ' Welcome BOSS ',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     color: Colors.grey.shade600,
                            //   ),
                            // ),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔍 Search Bar Widget
  Widget _searchBar() {
    return Container(
      key: const ValueKey('search'),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
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
