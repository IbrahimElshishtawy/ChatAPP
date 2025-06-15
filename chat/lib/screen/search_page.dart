import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTerm = "";
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> sendRequest(String toUserId) async {
    if (currentUser == null || currentUser?.uid == toUserId) return;

    final requestRef = FirebaseFirestore.instance.collection('requests');

    final existingRequest = await requestRef
        .where('from', isEqualTo: currentUser?.uid)
        .where('to', isEqualTo: toUserId)
        .get();

    if (existingRequest.docs.isEmpty) {
      await requestRef.add({
        'from': currentUser?.uid,
        'to': toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم إرسال الطلب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ℹ️ تم إرسال طلب مسبقًا'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Stream<QuerySnapshot> getUserStream() {
    final usersRef = FirebaseFirestore.instance.collection('users');

    if (searchTerm.trim().isEmpty) {
      // عرض جميع المستخدمين ما عدا الحالي
      return usersRef.snapshots();
    } else {
      return usersRef
          .where('searchKeywords', arrayContains: searchTerm.toLowerCase())
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث عن مستخدمين"),
        backgroundColor: const Color(0xFF2C688E),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF4CA6DF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "اكتب الاسم أو البريد الإلكتروني...",
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  searchTerm = val.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getUserStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (doc.id == currentUser?.uid) return false;

                  final name = (data['firstName'] ?? '').toLowerCase();
                  final email = (data['email'] ?? '').toLowerCase();

                  return searchTerm.isEmpty ||
                      name.contains(searchTerm) ||
                      email.contains(searchTerm);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا يوجد مستخدمين مطابقين",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final name = data['firstName'] ?? 'بدون اسم';
                    final email = data['email'] ?? '';
                    final userId = docs[index].id;

                    return Card(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: () => sendRequest(userId),
                          icon: const Icon(Icons.send),
                          label: const Text("إرسال"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
