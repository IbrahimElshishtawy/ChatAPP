import 'dart:ui';
import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'auth-card',
      child: Material(
        // ✅ مهم جدًا
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                padding: const EdgeInsets.all(22),
                color: Colors.white.withOpacity(0.18),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
