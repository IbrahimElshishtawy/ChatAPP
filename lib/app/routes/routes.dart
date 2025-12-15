import 'package:chat/screen/profile_page.dart';
import 'package:get/get.dart';
import '../../screen/home_page.dart';
import '../../screens/splash/splash_page.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/auth/register_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static final pages = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: profile, page: () => ProfilePage(user: )),
  ];
}
