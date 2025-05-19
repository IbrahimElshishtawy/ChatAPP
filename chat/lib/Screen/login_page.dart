import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class loginpage extends StatelessWidget {
  const loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 44, 104, 142),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 150),
              Center(
                child: Image.asset(
                  'assets/image/MetroUI_Messaging.webp',
                  height: 220,
                  width: 220,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(height: 1),
              Center(
                child: const Text(
                  'Welcome to Chat App',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  const Text(
                    'Please login to continue',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CustomTextField(
                hintext: 'Enter your email',
                labeltext: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your password',
                labeltext: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomBtn(textbtn: 'Login', onPressed: () {}),
              Row(
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Sign Up',
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
    );
  }
}
