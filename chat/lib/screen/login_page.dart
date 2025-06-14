import 'package:chat/widget/custom_btn.dart';
import 'package:chat/widget/custom_text.dart' hide CustomTextField;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _setSessionPersistence();
  }

  Future<void> _setSessionPersistence() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
  }

  Future<bool> _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return result != ConnectivityResult.none;
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    if (email == null ||
        password == null ||
        email!.isEmpty ||
        password!.isEmpty) {
      showSnack('Please enter both email and password');
      return;
    }

    if (!await _checkInternet()) {
      showSnack('No internet connection');
      return;
    }

    try {
      // ignore: use_build_context_synchronously
      showLoading(context);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // ignore: use_build_context_synchronously
      hideLoading(context);
      showSnack('Login successful');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      hideLoading(context);
      if (e.code == 'user-not-found') {
        showSnack('No user found with this email.');
      } else if (e.code == 'wrong-password') {
        showSnack('Incorrect password.');
      } else {
        showSnack('Login error: ${e.message}');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      hideLoading(context);
      showSnack('Unexpected error: ${e.toString()}');
    }
  }

  Future<void> _loginWithGoogle() async {
    if (!await _checkInternet()) {
      showSnack('No internet connection');
      return;
    }

    try {
      // ignore: use_build_context_synchronously
      showLoading(context);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // ignore: use_build_context_synchronously
        hideLoading(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      hideLoading(context);
      showSnack('Login with Google successful');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // ignore: use_build_context_synchronously
      hideLoading(context);
      showSnack('Google sign-in failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C688E), Color(0xFFEAF4F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.17),
                Image.asset('assets/image/MetroUI_Messaging.webp', height: 150),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Chat App',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email'),
                ),
                CustomTextField(
                  hintext: 'Enter your email',
                  obscureText: false,
                  onChanged: (value) => email = value,
                  suffixIcon: null,
                  labeltext: '',
                ),

                const SizedBox(height: 15),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                CustomTextField(
                  hintext: 'Enter your password',
                  obscureText: obscurePassword,
                  onChanged: (value) => password = value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  labeltext: '',
                ),

                const SizedBox(height: 30),

                CustomBtn(textbtn: 'Login', onPressed: _loginWithEmail),

                const SizedBox(height: 10),

                // Google login button with image icon
                ElevatedButton.icon(
                  onPressed: _loginWithGoogle,
                  icon: Image.asset(
                    'assets/image/google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
