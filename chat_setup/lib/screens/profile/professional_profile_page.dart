import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';

class ProfessionalProfilePage extends StatelessWidget {
  const ProfessionalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final industryCtrl = TextEditingController(text: userCtrl.user.value?.industry);
    final companyCtrl = TextEditingController(text: userCtrl.user.value?.company);
    final jobTitleCtrl = TextEditingController(text: userCtrl.user.value?.jobTitle);
    final bioCtrl = TextEditingController(text: userCtrl.user.value?.professionalBio);
    final reasonCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('الحساب المهني')),
      body: Obx(() {
        final user = userCtrl.user.value;
        if (user == null) return const Center(child: CircularProgressIndicator());

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'معلوماتك المهنية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: industryCtrl,
              decoration: const InputDecoration(labelText: 'المجال / الصناعة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: companyCtrl,
              decoration: const InputDecoration(labelText: 'الشركة / المؤسسة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jobTitleCtrl,
              decoration: const InputDecoration(labelText: 'المسمى الوظيفي', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'نبذة مهنية مختصرة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userCtrl.updateProfessionalDetails(
                  industry: industryCtrl.text,
                  company: companyCtrl.text,
                  jobTitle: jobTitleCtrl.text,
                  professionalBio: bioCtrl.text,
                );
                Get.snackbar('تم', 'تم تحديث المعلومات المهنية بنجاح');
              },
              child: const Text('تحديث البيانات'),
            ),
            const Divider(height: 40),
            const Text(
              'توثيق الحساب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('حالة التوثيق: '),
                Text(
                  user.isVerified ? 'موثق ✅' : 'غير موثق ❌',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: user.isVerified ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!user.isVerified) ...[
              const Text('تقدم بطلب للحصول على علامة التوثيق الزرقاء من خلال توضيح سبب حاجتك للتوثيق:'),
              const SizedBox(height: 8),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'اكتب السبب هنا...', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if (reasonCtrl.text.isNotEmpty) {
                    userCtrl.requestVerification(reasonCtrl.text);
                    Get.snackbar('تم الإرسال', 'طلب التوثيق قيد المراجعة حالياً');
                  } else {
                    Get.snackbar('تنبيه', 'يرجى كتابة سبب التوثيق');
                  }
                },
                child: const Text('إرسال طلب توثيق', style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        );
      }),
    );
  }
}
