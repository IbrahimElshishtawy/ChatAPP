// ignore_for_file: file_names, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  Future<void> respondToRequest(String requestId, String status) async {
    if (kDebugMode) {
      print('Responding to request $requestId with status: $status');
    }
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (kDebugMode) {
        print('No user logged in.');
      }
      return const Center(child: Text("Please login first"));
    }

    if (kDebugMode) {
      print('Fetching friend requests for UID: ${currentUser.uid}');
    }

    final requestsStream = FirebaseFirestore.instance
        .collection('requests')
        .where('to', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
        backgroundColor: const Color(0xFF1A374D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F6F9),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (kDebugMode) {
              print('Loading requests...');
            }
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;
          if (kDebugMode) {
            print('Received ${requests.length} requests.');
          }

          if (requests.isEmpty) {
            return const Center(
              child: Text(
                "No requests at the moment.",
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) {
              final request = requests[index];
              final data = request.data() as Map<String, dynamic>;
              final fromUserId = data['from'];
              if (kDebugMode) {
                print('Request from user ID: $fromUserId');
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(fromUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text(
                        "Loading...",
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final name = userData['firstName'] ?? 'User';
                  final email = userData['email'] ?? '';

                  if (kDebugMode) {
                    print('User name: $name, email: $email');
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade100,
                        child: const Icon(Icons.person, color: Colors.blueGrey),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              respondToRequest(request.id, 'accepted');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              respondToRequest(request.id, 'rejected');
                            },
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
