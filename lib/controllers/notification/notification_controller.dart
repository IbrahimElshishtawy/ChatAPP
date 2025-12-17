import 'package:get/get.dart';
import '../../core/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  @override
  void onInit() {
    _service.initAndSaveToken();
    super.onInit();
  }
}
