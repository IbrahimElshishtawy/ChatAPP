import 'package:chat/Screen/login_page.dart';
import 'package:flutter/material.dart';

void mmain() {
  runApp(const chat());
}

// ignore: camel_case_types
class chat extends StatelessWidget {
  const chat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: loginpage()));
  }
}
