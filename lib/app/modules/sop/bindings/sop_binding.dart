import 'package:get/get.dart';
import 'package:app_sop/app/modules/sop/controllers/sop_controller.dart';

class SopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SopController>(
      () => SopController(),
    );
  }
}
