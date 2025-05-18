import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBtn extends StatelessWidget {
  CustomBtn({
    super.key,
    this.textbtn,
    required Null Function() onPressed,
    required Null Function() ontap,
  });
  String? textbtn;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 60, 155, 227),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          '$textbtn',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
