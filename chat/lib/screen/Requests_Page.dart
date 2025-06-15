// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  Future<void> respondToRequest(
    BuildContext context,
    String requestId,
    String status,
  ) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .update({'status': status});

    // إظهار إشعار
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'accepted' ? '✅ تم قبول الطلب' : '❌ تم رفض الطلب',
        ),
        backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
      ),
    );
  }

  Future<String?> getUserName(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return userDoc.data()?['firstName'] ?? "مستخدم";
    }
    return "مستخدم";
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات المراسلة"),
        backgroundColor: const Color(0xFF2C688E),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 76, 166, 223),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('to', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد طلبات حاليًا",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final requestId = requests[index].id;
              final fromUserId = data['from'];

              return FutureBuilder<String?>(
                future: getUserName(fromUserId),
                builder: (context, snapshot) {
                  final senderName = snapshot.data ?? 'مستخدم';

                  return Card(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        "طلب من: $senderName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        "بانتظار ردك...",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => respondToRequest(
                              context,
                              requestId,
                              'accepted',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => respondToRequest(
                              context,
                              requestId,
                              'rejected',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
