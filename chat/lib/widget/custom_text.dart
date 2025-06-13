import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    this.hintext,
    this.labeltext,
    this.obscureText,
    this.onChanged,
  });
  Function(String)? onChanged;
  String? hintext;
  String? labeltext;
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 60,
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText ?? false,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        decoration: InputDecoration(
          labelText: '$labeltext',
          filled: true,
          labelStyle: TextStyle(color: const Color.fromARGB(255, 8, 13, 16)),
          hintText: '$hintext',
          hintStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 60, 144, 200),
            ),
          ),
        ),
      ),
    );
  }
}
