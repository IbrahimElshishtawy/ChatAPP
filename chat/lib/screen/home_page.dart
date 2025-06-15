import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/widget/custom_modelD.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (kDebugMode) {
        print('No user is logged in.');
      }
      return 'User';
    }

    if (kDebugMode) {
      print('Fetching user name for UID: $uid');
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();
    final name = data != null ? data['firstName'] ?? 'User' : 'User';
    if (kDebugMode) {
      print('User name fetched: $name');
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print('HomePage build started');
    }

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
            onPressed: () {
              if (kDebugMode) {
                print('Search button pressed');
              }
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            onPressed: () {
              if (kDebugMode) {
                print('Requests button pressed');
              }
              Navigator.pushNamed(context, '/requests');
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (kDebugMode) {
                print('PopupMenu selected: $value');
              }
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
                    if (kDebugMode) {
                      print('Navigating to profile page');
                    }
                    Navigator.pushNamed(
                      // ignore: use_build_context_synchronously
                      context,
                      '/profile',
                      arguments: userProfile,
                    );
                  }
                }
              } else if (value == 'logout') {
                if (kDebugMode) {
                  print('Logging out...');
                }
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
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
            if (kDebugMode) {
              print('Listening to accepted requests stream...');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              );
            }

            final acceptedUsers = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final from = data['from'];
              final to = data['to'];
              final otherUserId = currentUser.uid == from ? to : from;
              if (kDebugMode) {
                print('Accepted user ID: $otherUserId');
              }
              return otherUserId;
            }).toList();

            if (acceptedUsers.isEmpty) {
              if (kDebugMode) {
                print('No accepted users found.');
              }
              return const Center(
                child: Text(
                  "No accepted users yet.",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
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
                if (kDebugMode) {
                  print('Fetched ${users.length} users to display');
                }

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
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.message,
                          color: Colors.blueGrey,
                        ),
                        onTap: () {
                          if (kDebugMode) {
                            print('Tapped on user: $name (ID: $id)');
                          }
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
    );
  }
}
