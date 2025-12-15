// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final TextEditingController emailController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();
// final TextEditingController confirmPasswordController = TextEditingController();
// final TextEditingController firstNameController = TextEditingController();
// final TextEditingController lastNameController = TextEditingController();
// final TextEditingController addressController = TextEditingController();
// final TextEditingController phoneController = TextEditingController();

// final controllers = [
//   emailController,
//   passwordController,
//   confirmPasswordController,
//   firstNameController,
//   lastNameController,
//   addressController,
//   phoneController,
// ];

// void clearAllFields() {
//   for (final controller in controllers) {
//     controller.clear();
//   }
// }

// final FirebaseFirestore firestore = FirebaseFirestore.instance;
// final FirebaseAuth auth = FirebaseAuth.instance;

// void showLoading(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) =>
//         const Center(child: CircularProgressIndicator(color: Colors.blue)),
//   );
// }
