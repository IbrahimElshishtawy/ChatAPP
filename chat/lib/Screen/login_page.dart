import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C688E),
              Color(0xFFEAF4F7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/image/MetroUI_Messaging.webp',
                height: 150,
              ),
              const SizedBox(height: 16),
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),

              // حقل الإيميل
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintext: 'Enter your email',
                labeltext: '',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // حقل الباسورد
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintext: 'Enter your password',
                labeltext: '',
                obscureText: true,
              ),

              const Spacer(),
              CustomBtn(
                textbtn: 'Login',
                onPressed: () {
                  // TODO: login logic
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF14A0E6),
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
