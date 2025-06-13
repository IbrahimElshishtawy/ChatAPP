import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String? email, password, confirmPassword, firstName, lastName, address, phone;

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 70,
                        color: Color(0xFF2C688E),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Fields
                      CustomTextField(
                        hintext: 'Enter your first name',
                        labeltext: 'First Name',
                        obscureText: false,
                        onChanged: (data) => firstName = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Enter your last name',
                        labeltext: 'Last Name',
                        obscureText: false,
                        onChanged: (data) => lastName = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Enter your address',
                        labeltext: 'Address',
                        obscureText: false,
                        onChanged: (data) => address = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Enter your email',
                        labeltext: 'Email',
                        obscureText: false,
                        onChanged: (data) => email = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Enter your phone number',
                        labeltext: 'Phone Number',
                        obscureText: false,
                        onChanged: (data) => phone = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Enter your password',
                        labeltext: 'Password',
                        obscureText: true,
                        onChanged: (data) => password = data,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        hintext: 'Confirm your password',
                        labeltext: 'Confirm Password',
                        obscureText: true,
                        onChanged: (data) => confirmPassword = data,
                      ),
                      const SizedBox(height: 25),

                      CustomBtn(
                        textbtn: 'Register',
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          if ([
                                email,
                                password,
                                confirmPassword,
                                firstName,
                                lastName,
                                address,
                                phone,
                              ].contains(null) ||
                              [
                                email,
                                password,
                                confirmPassword,
                                firstName,
                                lastName,
                                address,
                                phone,
                              ].any((e) => e!.isEmpty)) {
                            showSnack('Please fill all fields');
                            return;
                          }

                          if (password != confirmPassword) {
                            showSnack('Passwords do not match');
                            return;
                          }

                          showLoading(context);

                          // TODO: Implement registration logic (Firebase or others)

                          await Future.delayed(const Duration(seconds: 2));
                          hideLoading(context);
                          showSnack('Account created successfully');

                          // Navigate to login or home
                          // Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      const SizedBox(height: 8),

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
                                color: Color(0xFF14A0E6),
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
      ),
    );
  }
}
