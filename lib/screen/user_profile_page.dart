// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserProfilePage extends StatelessWidget {
//   final String userId;

//   const UserProfilePage({super.key, required this.userId});

//   Future<DocumentSnapshot> getUserData() {
//     return FirebaseFirestore.instance.collection('users').doc(userId).get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text("User Profile"),
//         backgroundColor: const Color(0xFF2C688E),
//         centerTitle: true,
//         elevation: 3,
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("❌ not found data user."));
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           final firstName = data['firstName'] ?? '';
//           final lastName = data['lastName'] ?? '';
//           final name = '$firstName $lastName'.trim().isEmpty
//               ? 'not found name'
//               : '$firstName $lastName';
//           final email = data['email'] ?? 'not found email';
//           final phone = data['phone'] ?? 'not found phone';
//           final address = data['address'] ?? 'not found address';

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       const CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.blueAccent,
//                         child: Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2C688E),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         email,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 _buildInfoCard(Icons.phone, "Phone number", phone),
//                 const SizedBox(height: 10),
//                 _buildInfoCard(Icons.home, "Address", address),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoCard(IconData icon, String title, String value) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.blueAccent),
//         title: Text(title),
//         subtitle: Text(
//           value,
//           style: const TextStyle(fontSize: 14, color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }
