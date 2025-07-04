import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat/widget/custom_modelD.dart'; // يحتوي على كلاس UserProfile

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required UserProfile user});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! UserProfile) {
      if (kDebugMode) {
        print("❌ No user data provided to ProfilePage.");
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user data found.')),
      );
    }

    final user = args;

    if (kDebugMode) {
      print("🧾 ProfilePage opened");
      print("👤 User Data: ${user.firstName} ${user.lastName}");
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
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C688E),
              ),
            ),
            const SizedBox(height: 30),
            buildInfoCard(Icons.email, 'Email', user.email),
            buildInfoCard(Icons.phone, 'Phone', user.phone),
            buildInfoCard(Icons.location_on, 'Address', user.address),
            const SizedBox(height: 10),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/editProfile',
                        arguments: user,
                      );

                      if (result != null && result is Map) {
                        Navigator.pushReplacementNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          '/profile',
                          arguments: UserProfile(
                            id: user.id,
                            firstName: result['firstName'] ?? user.firstName,
                            lastName: result['lastName'] ?? user.lastName,
                            email: result['email'] ?? user.email,
                            phone: result['phone'] ?? user.phone,
                            address: result['address'] ?? user.address,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 206, 202, 198),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
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
