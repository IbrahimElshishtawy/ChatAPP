// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat/widget/custom_modelD.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 'User';
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();
    return data != null ? data['firstName'] ?? 'User' : 'User';
  }

  Future<bool> hasNewMessage(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', isEqualTo: otherUserId)
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .limit(1)
        .get();

    return messagesSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A374D),
        elevation: 0,
        title: FutureBuilder<String>(
          future: getUserName(),
          builder: (context, snapshot) {
            final name = snapshot.data ?? 'User';
            return Row(
              children: [
                const Icon(Icons.home, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Welcome, $name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/requests'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'profile') {
                final uid = currentUser?.uid;
                if (uid != null) {
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get();
                  final data = doc.data();
                  if (data != null) {
                    final userProfile = UserProfile(
                      firstName: data['firstName'] ?? '',
                      lastName: data['lastName'] ?? '',
                      address: data['address'] ?? '',
                      email: data['email'] ?? '',
                      phone: data['phone'] ?? '',
                      id: uid,
                    );
                    Navigator.pushNamed(
                      context,
                      '/profile',
                      arguments: userProfile,
                    );
                  }
                }
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('status', isEqualTo: 'accepted')
              .where(
                Filter.or(
                  Filter('from', isEqualTo: currentUser!.uid),
                  Filter('to', isEqualTo: currentUser.uid),
                ),
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              );
            }

            final acceptedUsers = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final from = data['from'];
              final to = data['to'];
              return currentUser.uid == from ? to : from;
            }).toList();

            if (acceptedUsers.isEmpty) {
              return const Center(
                child: Text(
                  "No chats yet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: acceptedUsers)
                  .get(),
              builder: (context, usersSnapshot) {
                if (!usersSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blueGrey),
                  );
                }

                final users = usersSnapshot.data!.docs;

                return ListView.separated(
                  itemCount: users.length,
                  padding: const EdgeInsets.only(top: 20),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final doc = users[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['firstName'] ?? 'User';
                    final id = doc.id;

                    return FutureBuilder<bool>(
                      future: hasNewMessage(id),
                      builder: (context, snapshot) {
                        final hasNew = snapshot.data ?? false;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Icon(
                              hasNew
                                  ? Icons.chat_bubble
                                  : Icons.chat_bubble_outline,
                              color: hasNew ? Colors.blueAccent : Colors.grey,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/chat',
                                arguments: {'id': id, 'name': name},
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
