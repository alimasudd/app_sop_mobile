import 'package:get/get.dart';
import 'package:app_sop/app/modules/kategori_sop/controllers/kategori_sop_controller.dart';

class KategoriSopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KategoriSopController>(
      () => KategoriSopController(),
    );
  }
}
