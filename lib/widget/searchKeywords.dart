// // ignore_for_file: file_names
// import 'package:chat/widget/textedit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<void> registerUser() async {
//   final auth = FirebaseAuth.instance;
//   final firestore = FirebaseFirestore.instance;

//   final firstName = firstNameController.text.trim();
//   final lastName = lastNameController.text.trim();
//   final email = emailController.text.trim();
//   final password = passwordController.text.trim();
//   final phone = phoneController.text.trim();
//   final address = addressController.text.trim();

//   final userCredential = await auth.createUserWithEmailAndPassword(
//     email: email,
//     password: password,
//   );

//   final uid = userCredential.user!.uid;

//   await firestore.collection('users').doc(uid).set({
//     'firstName': firstName,
//     'lastName': lastName,
//     'email': email,
//     'phone': phone,
//     'address': address,
//     'searchKeywords': generateSearchKeywords(firstName, email),
//   });
// }

// List<String> generateSearchKeywords(String firstName, String email) {
//   final keywords = <String>[];

//   if (firstName.isNotEmpty) {
//     keywords.add(firstName.toLowerCase());
//   }

//   if (email.isNotEmpty) {
//     keywords.add(email.toLowerCase());
//   }
//   final nameParts = firstName.split(' ');
//   for (final part in nameParts) {
//     if (part.isNotEmpty) {
//       keywords.add(part.toLowerCase());
//     }
//   }
//   if (nameParts.length > 1) {
//     final lastName = nameParts.last;
//     keywords.add(lastName.toLowerCase());
//   }
//   keywords.add('${firstName.toLowerCase()} ${email.toLowerCase()}');
//   keywords.add('${email.toLowerCase()} ${firstName.toLowerCase()}');
//   keywords.add('${firstName.toLowerCase()} ${firstName.toLowerCase()}');
//   keywords.add('${email.toLowerCase()} ${email.toLowerCase()}');
//   keywords.add(
//     '${firstName.toLowerCase()} ${firstName.toLowerCase()} ${email.toLowerCase()}',
//   );
//   keywords.add(
//     '${email.toLowerCase()} ${email.toLowerCase()} ${firstName.toLowerCase()}',
//   );
//   keywords.add(
//     '${firstName.toLowerCase()} ${email.toLowerCase()} ${firstName.toLowerCase()}',
//   );
//   keywords.add(
//     '${email.toLowerCase()} ${firstName.toLowerCase()} ${email.toLowerCase()}',
//   );
//   keywords.add(
//     '${firstName.toLowerCase()} ${firstName.toLowerCase()} ${email.toLowerCase()}',
//   );
//   keywords.add(
//     '${email.toLowerCase()} ${email.toLowerCase()} ${firstName.toLowerCase()}',
//   );
//   keywords.add(
//     '${firstName.toLowerCase()} ${email.toLowerCase()} ${firstName.toLowerCase()} ${email.toLowerCase()}',
//   );
//   keywords.add(
//     '${email.toLowerCase()} ${firstName.toLowerCase()} ${email.toLowerCase()} ${firstName.toLowerCase()}',
//   );
//   return keywords;
// }
