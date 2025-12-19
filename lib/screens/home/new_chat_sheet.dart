import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user/user_controller.dart';

class NewChatSheet extends StatelessWidget {
  const NewChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'ابدأ شات جديد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// 🔍 Search
          TextField(
            onChanged: userCtrl.search,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو الهاتف أو الإيميل',
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
                return const Center(child: Text('لا يوجد مستخدمين'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final u = users[i];

                  return ListTile(
                    leading: CircleAvatar(child: Text(u.name[0])),
                    title: Text(u.name),
                    subtitle: Text(u.email ?? u.phone ?? ''),
                    onTap: () {
                      Get.back();
                      Get.snackbar('تم', 'بدء شات مع ${u.name}');
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
