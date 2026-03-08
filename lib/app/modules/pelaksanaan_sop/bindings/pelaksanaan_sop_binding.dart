import 'package:get/get.dart';
import '../controllers/pelaksanaan_sop_controller.dart';

class PelaksanaanSopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelaksanaanSopController>(
      () => PelaksanaanSopController(),
    );
  }
}
