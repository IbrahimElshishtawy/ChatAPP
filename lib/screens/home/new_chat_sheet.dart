import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user/user_controller.dart';

class NewChatSheet extends StatelessWidget {
  const NewChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⬆ Drag Handle
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const Text(
            'شات جديد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// 🔍 Search
          TextField(
            onChanged: userCtrl.search,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو الهاتف',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 👥 Users List
          Expanded(
            child: Obx(() {
              final users = userCtrl.filteredUsers;

              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد مستخدمين',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final u = users[i];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        u.name.isNotEmpty ? u.name[0] : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(u.name),
                    subtitle: Text(
                      (u.phone ?? '').isNotEmpty
                          ? u.phone ?? ''
                          : u.email ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Get.back();
                      Get.snackbar('تم', 'بدء شات مع ${u.name}');
                      // هنا بعدين نعمل createChat
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
