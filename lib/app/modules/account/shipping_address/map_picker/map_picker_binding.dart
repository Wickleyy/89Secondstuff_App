import 'package:get/get.dart';
import 'map_picker_controller.dart';

class MapPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapPickerController>(() => MapPickerController());
  }
}
