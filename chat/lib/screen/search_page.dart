import 'package:chat/widget/custom_modelD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserProfile? user;

  const SearchPage({super.key, this.user});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTerm = "";
  final currentUser = FirebaseAuth.instance.currentUser;
  Set<String> sentRequestUserIds = {};

  Future<void> sendRequest(String toUserId) async {
    if (currentUser == null || currentUser!.uid == toUserId) return;

    final requestRef = FirebaseFirestore.instance.collection('requests');

    final existingRequest = await requestRef
        .where('from', isEqualTo: currentUser!.uid)
        .where('to', isEqualTo: toUserId)
        .get();

    if (existingRequest.docs.isEmpty) {
      await requestRef.add({
        'from': currentUser!.uid,
        'to': toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        sentRequestUserIds.add(toUserId);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Request sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ℹ️ Request already sent'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Stream<QuerySnapshot> getUserStream() {
    final usersRef = FirebaseFirestore.instance.collection('users');

    if (searchTerm.trim().isEmpty) {
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
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        title: const Text("Search Users"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF2C688E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name or email...",
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
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
                  final userId = doc.id;
                  if (sentRequestUserIds.contains(userId)) return false;

                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['firstName'] ?? '').toLowerCase();
                  final email = (data['email'] ?? '').toLowerCase();

                  return searchTerm.isEmpty ||
                      name.contains(searchTerm) ||
                      email.contains(searchTerm);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No matching users found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final userId = docs[index].id;
                    final isCurrentUser = userId == currentUser?.uid;

                    final rawName = data['firstName'];
                    String name =
                        (rawName != null &&
                            rawName.toString().trim().isNotEmpty)
                        ? rawName.toString()
                        : 'No name (this profile test ui only)';

                    if (isCurrentUser) {
                      name += " (you)";
                    }

                    final email = data['email'] ?? '';

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFF2C688E),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: isCurrentUser
                              ? null
                              : () => sendRequest(userId),
                          icon: const Icon(Icons.send),
                          label: const Text("Send"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C688E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
