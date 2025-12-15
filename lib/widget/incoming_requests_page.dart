// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class IncomingRequestsPage extends StatelessWidget {
//   const IncomingRequestsPage({super.key});

//   Future<void> updateRequestStatus(String requestId, String newStatus) async {
//     await FirebaseFirestore.instance
//         .collection('requests')
//         .doc(requestId)
//         .update({'status': newStatus});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return const Scaffold(body: Center(child: Text("User not logged in.")));
//     }

//     final requestsStream = FirebaseFirestore.instance
//         .collection('requests')
//         .where('to', isEqualTo: currentUser.uid)
//         .where('status', isEqualTo: 'pending')
//         .snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Incoming Requests"),
//         backgroundColor: const Color(0xFF2C688E),
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: requestsStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final docs = snapshot.data!.docs;

//           if (docs.isEmpty) {
//             return const Center(child: Text("No incoming requests."));
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final request = docs[index];
//               final fromUserId = request['from'];

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(fromUserId)
//                     .get(),
//                 builder: (context, userSnapshot) {
//                   if (!userSnapshot.hasData) {
//                     return const ListTile(title: Text("Loading user..."));
//                   }

//                   final userData =
//                       userSnapshot.data!.data() as Map<String, dynamic>;
//                   final name = userData['firstName'] ?? 'Unknown';
//                   final email = userData['email'] ?? '';

//                   return ListTile(
//                     title: Text(name),
//                     subtitle: Text(email),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.check, color: Colors.green),
//                           onPressed: () {
//                             updateRequestStatus(request.id, 'accepted');
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             updateRequestStatus(request.id, 'rejected');
//                           },
//                         ),
//                       ],
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
