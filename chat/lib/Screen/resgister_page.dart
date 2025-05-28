import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  String? email, password, confirmpassword, firstname, lastname, address, phone;

  void showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C688E), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_alt_1, size: 70, color: Color(0xFF2C688E)),
                    const SizedBox(height: 10),
                    const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Input Fields
                    CustomTextField(
                      onChanged: (data) => firstname = data,
                      hintext: 'Enter your first name',
                      labeltext: 'First Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => lastname = data,
                      hintext: 'Enter your last name',
                      labeltext: 'Last Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => address = data,
                      hintext: 'Enter your address',
                      labeltext: 'Address',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => email = data,
                      hintext: 'Enter your email',
                      labeltext: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => phone = data,
                      hintext: 'Enter your phone number',
                      labeltext: 'Phone Number',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => password = data,
                      hintext: 'Enter your password',
                      labeltext: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      onChanged: (data) => confirmpassword = data,
                      hintext: 'Confirm your password',
                      labeltext: 'Confirm Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),

                    CustomBtn(
                      textbtn: 'Register',
                      onPressed: () async {
                        if ([email, password, confirmpassword, firstname, lastname, address, phone]
                            .contains(null) ||
                            [email, password, confirmpassword, firstname, lastname, address, phone]
                                .any((e) => e!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        if (password != confirmpassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        showLoading(context); // Show loader

                        try {
                          final auth = FirebaseAuth.instance;
                          final userCredential = await auth.createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );

                          final userId = userCredential.user!.uid;
                          await FirebaseFirestore.instance.collection('users').doc(userId).set({
                            'firstname': firstname,
                            'lastname': lastname,
                            'address': address,
                            'phone': phone,
                            'email': email,
                          });

                          hideLoading(context); // Hide loader
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration successful')),
                          );

                          Navigator.pushNamed(context, 'home');
                        } on FirebaseAuthException catch (e) {
                          hideLoading(context); // Hide loader
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message ?? 'Registration failed')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromRGBO(20, 160, 230, 0.816),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
