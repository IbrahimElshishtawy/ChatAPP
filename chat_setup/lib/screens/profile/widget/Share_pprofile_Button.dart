// =====================
// Share Profile Button Widget
// =====================
import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Implement Share functionality here
        },
        child: const Text('Share Profile'),
      ),
    );
  }
}
