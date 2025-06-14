// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    log(
      'Trying to login with Email: $email, Password: $password',
      name: 'LoginPage',
    );

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // تسجيل الدخول
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;
      log('User logged in: ${user?.email}', name: 'LoginPage');

      if (user == null) {
        throw FirebaseAuthException(
          code: 'unknown-error',
          message: 'Unexpected error occurred',
        );
      }

      // جلب بيانات المستخدم من Firestore
      final String uid = user.uid;
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (doc.exists) {
          final userData = doc.data()!;
          log('User data loaded: $userData', name: 'LoginPage');

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful')));

          await Future.delayed(const Duration(milliseconds: 500));

          Navigator.pushReplacementNamed(context, '/home', arguments: userData);
        } else {
          log('No Firestore document found for user $uid', name: 'LoginPage');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found in Firestore')),
          );
          await FirebaseAuth.instance.signOut();
        }
      } on FirebaseException catch (e) {
        log('Firestore error: ${e.message}', name: 'LoginPage');

        String message = 'An error occurred';
        if (e.code == 'permission-denied') {
          message =
              'You do not have permission to access this data. Please check Firestore rules.';
        } else if (e.code == 'unavailable') {
          message = 'Service unavailable. Please try again later.';
        } else {
          message = e.message ?? message;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      log('Login error: ${e.code} - ${e.message}', name: 'LoginPage');

      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'This email is not registered. Please create a new account.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        message = 'The email format is invalid.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many login attempts. Try again later.';
      } else {
        message = e.message ?? message;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C688E), Color(0xFFEAF4F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.17),
              Image.asset('assets/image/MetroUI_Messaging.webp', height: 150),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Chat App',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please login to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: emailController,
                hintext: 'Enter your email',
                labeltext: 'Email',
                obscureText: false,
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: emailController.text.isNotEmpty
                      ? Colors.green
                      : const Color.fromARGB(255, 100, 111, 119),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                hintext: 'Enter your password',
                labeltext: 'Password',
                obscureText: !isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 97, 106, 112),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              CustomBtn(
                textbtn: isLoading ? 'Loading...' : 'Login',
                onPressed: () async {
                  if (!isLoading) {
                    await loginUser();
                  }
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 43, 159, 217),
                        fontSize: 14,
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
    );
  }
}
