import 'package:get/get.dart';
import '../controllers/langkah_sop_controller.dart';

class LangkahSopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LangkahSopController>(
      () => LangkahSopController(),
    );
  }
}
