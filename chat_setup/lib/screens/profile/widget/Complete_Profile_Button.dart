// =====================
// Complete Profile Button Widget
// =====================
import 'package:flutter/material.dart';

class CompleteProfileButton extends StatelessWidget {
  const CompleteProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Please complete your profile!',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
