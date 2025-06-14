import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final String labeltext;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Function(String)? onChanged; // ✅ تعريف onChanged هنا

  const CustomTextField({
    super.key,
    required this.hintext,
    required this.labeltext,
    required this.obscureText,
    this.controller,
    this.suffixIcon,
    this.onChanged, // ✅ تمريرها في الكونستركتور
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintext,
        labelText: labeltext,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged, // ✅ استخدام onChanged داخل الـ TextFormField
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
