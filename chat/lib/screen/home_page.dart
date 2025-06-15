import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF4CA6DF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C688E),
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
                    'Welcome $name',
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
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get();
                  if (doc.exists) {
                    final data = doc.data();
                    final userProfile = UserProfile(
                      firstName: data?['firstName'] ?? '',
                      lastName: data?['lastName'] ?? '',
                      address: data?['address'] ?? '',
                      email: data?['email'] ?? '',
                      phone: data?['phone'] ?? '',
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(
                      // ignore: use_build_context_synchronously
                      context,
                      '/profile',
                      arguments: userProfile,
                    );
                  }
                }
              } else if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('الملف الشخصي'),
              ),
              const PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "المستخدمين الذين تم قبولهم:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('from', isEqualTo: currentUser!.uid)
                  .where('status', isEqualTo: 'accepted')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                final acceptedUsers = snapshot.data!.docs
                    .map((doc) => doc['to'] as String)
                    .toList();

                if (acceptedUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا يوجد مستخدمين تم قبولهم.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    return ListView.builder(
                      itemCount: usersSnapshot.data!.docs.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final doc = usersSnapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['firstName'] ?? 'مستخدم';
                        final id = doc.id;

                        return Card(
                          color: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
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
                            trailing: const Icon(
                              Icons.message,
                              color: Colors.white70,
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
            ),
          ),
        ],
      ),
    );
  }
}
