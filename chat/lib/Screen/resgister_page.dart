import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class ResgisterPage extends StatelessWidget {
  const ResgisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 30);
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
              Center(
                child: Text(
                  'Please register to continue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintext: 'Enter your first name',
                labeltext: 'First Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your last name',
                labeltext: 'Last Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your address',
                labeltext: 'Address',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your email',
                labeltext: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your phone number',
                labeltext: 'Phone Number',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Enter your password',
                labeltext: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintext: 'Confirm your password',
                labeltext: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomBtn(textbtn: 'Register', onPressed: () {}),
              Row(
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromRGBO(20, 160, 230, 0.816),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  sizedBox,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
