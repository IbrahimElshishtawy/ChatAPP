import 'package:flutter/material.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final controllers = [
  emailController,
  passwordController,
  confirmPasswordController,
  firstNameController,
  lastNameController,
  addressController,
  phoneController,
];
void dispose() {
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  firstNameController.dispose();
  lastNameController.dispose();
  addressController.dispose();
  phoneController.dispose();
}

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        const Center(child: CircularProgressIndicator(color: Colors.blue)),
  );
}
