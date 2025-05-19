import 'package:chat/Screen/login_page.dart';
import 'package:chat/Screen/resgister_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 3)); // تأخير لعرض السبلاتش شوية
  runApp(const ChatApp());
}

// ignore: camel_case_types
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => loginpage(),
        '/register': (context) => ResgisterPage(),
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: loginpage()),
    );
  }
}
