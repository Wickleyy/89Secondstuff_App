import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  var orderNotification = true.obs;
  var promoNotification = true.obs;
  var reviewNotification = false.obs;
  var accountNotification = true.obs;
  var newsNotification = false.obs;

  void toggleOrderNotification(bool value) {
    orderNotification.value = value;
    _saveSettings();
  }

  void togglePromoNotification(bool value) {
    promoNotification.value = value;
    _saveSettings();
  }

  void toggleReviewNotification(bool value) {
    reviewNotification.value = value;
    _saveSettings();
  }

  void toggleAccountNotification(bool value) {
    accountNotification.value = value;
    _saveSettings();
  }

  void toggleNewsNotification(bool value) {
    newsNotification.value = value;
    _saveSettings();
  }

  void _saveSettings() {
    // TODO: Simpan ke API atau local storage
  }

  void resetToDefault() {
    orderNotification.value = true;
    promoNotification.value = true;
    reviewNotification.value = false;
    accountNotification.value = true;
    newsNotification.value = false;
    _saveSettings();
  }
}