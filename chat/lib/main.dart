import 'package:chat/screen/Requests_Page.dart';
import 'package:chat/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat/screen/login_page.dart';
import 'package:chat/screen/rgister_page.dart';
import 'package:chat/screen/home_page.dart';
import 'package:chat/screen/profile_page.dart';
import 'package:chat/screen/EditProfile_page.dart';

import 'package:chat/screen/chat_page.dart';
import 'package:chat/widget/custom_modelD.dart'; // يحتوي على كلاس UserProfile

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/requests': (context) => const RequestsPage(),
        '/search': (context) => const SearchPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          if (settings.arguments is UserProfile) {
            final user = settings.arguments as UserProfile;
            return MaterialPageRoute(
              builder: (context) => ProfilePage(user: user),
            );
          } else {
            return _errorRoute('Invalid data for ProfilePage');
          }
        }

        if (settings.name == '/editProfile') {
          if (settings.arguments is UserProfile) {
            final user = settings.arguments as UserProfile;
            return MaterialPageRoute(
              builder: (context) => EditProfilePage(user: user),
            );
          } else {
            return _errorRoute('Invalid data for EditProfilePage');
          }
        }

        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null &&
              args.containsKey('id') &&
              args.containsKey('name')) {
            return MaterialPageRoute(
              builder: (context) => ChatPage(
                otherUserId: args['id'],
                otherUserName: args['name'],
              ),
            );
          } else {
            return _errorRoute('Invalid data for ChatPage');
          }
        }

        return _errorRoute('Page Not Found');
      },
    );
  }

  Route _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
