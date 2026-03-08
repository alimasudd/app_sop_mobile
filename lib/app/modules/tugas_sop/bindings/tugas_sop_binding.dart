import 'package:get/get.dart';
import '../controllers/tugas_sop_controller.dart';

class TugasSopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TugasSopController>(
      () => TugasSopController(),
    );
  }
}
