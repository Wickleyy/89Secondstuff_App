import 'package:get/get.dart';
import 'notification_settings_controller.dart';

class NotificationSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationSettingsController>(
      () => NotificationSettingsController(),
    );
  }
}