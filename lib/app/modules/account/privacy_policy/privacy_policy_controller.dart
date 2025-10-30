import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  var agreeToTerms = false.obs;
  var agreeToPrivacy = false.obs;

  void toggleAgreeToTerms(bool value) {
    agreeToTerms.value = value;
  }

  void toggleAgreeToPrivacy(bool value) {
    agreeToPrivacy.value = value;
  }

  void acceptAll() {
    agreeToTerms.value = true;
    agreeToPrivacy.value = true;
  }
}