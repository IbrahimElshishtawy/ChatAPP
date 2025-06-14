import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBtn extends StatelessWidget {
  final String textbtn;
  final VoidCallback onPressed;

  const CustomBtn({super.key, required this.textbtn, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        width: 380,
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 60, 163, 227),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            textbtn,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
