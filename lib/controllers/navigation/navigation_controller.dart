import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt index = 0.obs;

  void change(int i) {
    index.value = i;
  }
}
