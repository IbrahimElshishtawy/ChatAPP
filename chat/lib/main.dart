import 'package:chat/screen/EditProfile_page.dart';
import 'package:chat/widget/custom_modelD.dart' as profile_page;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/screen/login_page.dart';
import 'package:chat/screen/rgister_page.dart';
import 'package:chat/screen/home_page.dart';
import 'package:chat/screen/profile_page.dart';
import 'package:chat/screen/chat_page.dart';
import 'package:chat/screen/Requests_Page.dart';
import 'package:chat/screen/search_page.dart';
import 'package:chat/widget/incoming_requests_page.dart';

void main() {
  runApp(
    const MaterialApp(home: SplashScreen(), debugShowCheckedModeBanner: false),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final currentUser = FirebaseAuth.instance.currentUser;

    // ignore: use_build_context_synchronously
    if (currentUser != null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const ChatApp(initialRoute: '/home')),
      );
    } else {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => const ChatApp(initialRoute: '/login'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ChatApp extends StatelessWidget {
  final String initialRoute;
  const ChatApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute, // ✅ يجي من SplashScreen
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/requests': (context) => const RequestsPage(),
        '/search': (context) => const SearchPage(),
        '/incoming_requests': (context) => const IncomingRequestsPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            final args = settings.arguments;
            if (args is profile_page.UserProfile) {
              return MaterialPageRoute(
                builder: (_) => ProfilePage(user: args),
                settings: settings,
              );
            }
            return _errorRoute('Invalid arguments for ProfilePage');

          case '/editProfile':
            if (settings.arguments is profile_page.UserProfile) {
              return MaterialPageRoute(
                builder: (_) => EditProfilePage(
                  user: settings.arguments as profile_page.UserProfile,
                ),
              );
            }
            return _errorRoute('Invalid arguments for EditProfilePage');

          case '/chat':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null &&
                args.containsKey('id') &&
                args.containsKey('name')) {
              return MaterialPageRoute(
                builder: (_) => ChatPage(
                  otherUserId: args['id'],
                  otherUserName: args['name'],
                ),
              );
            }
            return _errorRoute('Invalid arguments for ChatPage');

          default:
            return _errorRoute('Page Not Found');
        }
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
