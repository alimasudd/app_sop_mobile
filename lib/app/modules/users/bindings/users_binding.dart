import 'package:get/get.dart';
import 'package:test_maret/app/modules/users/controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
  }
}
