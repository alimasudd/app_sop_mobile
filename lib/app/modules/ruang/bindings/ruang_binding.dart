import 'package:get/get.dart';
import 'package:app_sop/app/modules/ruang/controllers/ruang_controller.dart';

class RuangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuangController>(() => RuangController());
  }
}
