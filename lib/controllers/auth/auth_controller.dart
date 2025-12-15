import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    user.bindStream(_service.authStateChanges());
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _service.login(email, password);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading.value = true;
      await _service.register(email: email, password: password, userData: data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
  }
}
