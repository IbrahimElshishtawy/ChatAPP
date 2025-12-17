import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt index = 0.obs;

  void change(int i) {
    if (index.value == i) return;
    index.value = i;
  }
}
