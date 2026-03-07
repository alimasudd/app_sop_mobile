import 'package:get/get.dart';
import 'package:app_sop/app/modules/area/controllers/area_controller.dart';

class AreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AreaController>(() => AreaController());
  }
}
