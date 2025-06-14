import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintext,
    this.labeltext,
    this.obscureText,
    this.onChanged,
    this.controller,
    this.suffixIcon,
  });

  final Function(String)? onChanged;
  final String? hintext;
  final String? labeltext;
  final bool? obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final bool isFilled = controller?.text.isNotEmpty ?? false;

    return SizedBox(
      width: 380,
      height: 60,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText ?? false,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          filled: true,
          suffixIcon:
              suffixIcon ??
              Icon(
                Icons.check_circle,
                color: isFilled
                    ? Colors.green
                    : const Color.fromARGB(255, 60, 144, 200),
              ),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 8, 13, 16)),
          hintText: hintext,
          hintStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 60, 144, 200),
            ),
          ),
        ),
      ),
    );
  }
}
