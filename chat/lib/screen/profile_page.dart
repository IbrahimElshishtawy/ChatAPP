import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat/widget/custom_modelD.dart'; // تأكد أن هذا الملف يحتوي على الكلاس UserProfile

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required UserProfile user});

  @override
  Widget build(BuildContext context) {
    // استقبال البيانات من الصفحة السابقة
    final user = ModalRoute.of(context)!.settings.arguments as UserProfile?;

    if (kDebugMode) {
      print("🧾 ProfilePage opened");
      print("👤 User Data: ${user?.firstName} ${user?.lastName}");
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C688E),
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 70, color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 20),
            if (user != null)
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C688E),
                ),
              ),
            const SizedBox(height: 30),
            buildInfoCard(Icons.email, 'Email', user?.email ?? 'Not provided'),
            buildInfoCard(Icons.phone, 'Phone', user?.phone ?? 'Not provided'),
            buildInfoCard(
              Icons.location_on,
              'Address',
              user?.address ?? 'Not provided',
            ),
            const SizedBox(height: 30),
            const Text(
              'Your account has been created successfully.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (user != null) {
                        if (kDebugMode) {
                          print("✏️ Navigating to EditProfile with user data");
                        }
                        Navigator.pushNamed(
                          context,
                          '/editProfile',
                          arguments: user,
                        );
                      } else {
                        if (kDebugMode) {
                          print("❌ User is null. Cannot edit profile.");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (kDebugMode) {
                        print("↩️ Back to previous screen");
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    if (kDebugMode) {
      print("📌 Displaying $title: $value");
    }

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2C688E), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
