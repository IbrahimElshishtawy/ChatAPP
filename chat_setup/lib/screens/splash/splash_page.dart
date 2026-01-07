import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Column(
        children: [
          const Spacer(),

          Image.asset('assets/image/logo.png', width: 120),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'إبراهيم الششتاوي',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
