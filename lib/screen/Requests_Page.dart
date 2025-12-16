// // ignore_for_file: file_names, deprecated_member_use

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class RequestsPage extends StatefulWidget {
//   const RequestsPage({super.key});

//   @override
//   State<RequestsPage> createState() => _RequestsPageState();
// }

// class _RequestsPageState extends State<RequestsPage> {
//   final currentUser = FirebaseAuth.instance.currentUser;

//   Future<void> respondToRequest(String requestId, String status) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('requests')
//           .doc(requestId)
//           .update({'status': status});

//       if (kDebugMode) {
//         print('✅ Responded to request $requestId with status: $status');
//       }

//       setState(() {}); // لإعادة بناء الصفحة وإخفاء الطلب المقبول أو المرفوض
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error responding to request: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (currentUser == null) {
//       return const Scaffold(body: Center(child: Text("Please login first")));
//     }

//     final requestsStream = FirebaseFirestore.instance
//         .collection('requests')
//         .where('to', isEqualTo: currentUser!.uid)
//         .where('status', isEqualTo: 'pending')
//         .snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Friend Requests"),
//         backgroundColor: const Color(0xFF1A374D),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       backgroundColor: const Color(0xFFF1F6F9),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: requestsStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final requests = snapshot.data!.docs;

//           if (requests.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No requests at the moment.",
//                 style: TextStyle(color: Colors.black87, fontSize: 16),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: requests.length,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             itemBuilder: (context, index) {
//               final request = requests[index];
//               final data = request.data() as Map<String, dynamic>;
//               final fromUserId = data['from'];

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(fromUserId)
//                     .get(),
//                 builder: (context, userSnapshot) {
//                   if (!userSnapshot.hasData) {
//                     return const ListTile(title: Text("Loading..."));
//                   }

//                   final userData =
//                       userSnapshot.data!.data() as Map<String, dynamic>;
//                   final name = userData['firstName'] ?? 'User';
//                   final email = userData['email'] ?? '';

// ignore_for_file: file_names

//                   return Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.blueGrey.shade100,
//                         child: const Icon(Icons.person, color: Colors.blueGrey),
//                       ),
//                       title: Text(
//                         name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       subtitle: Text(
//                         email,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.check, color: Colors.green),
//                             onPressed: () async {
//                               await respondToRequest(request.id, 'accepted');
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.close, color: Colors.red),
//                             onPressed: () async {
//                               await respondToRequest(request.id, 'rejected');
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
