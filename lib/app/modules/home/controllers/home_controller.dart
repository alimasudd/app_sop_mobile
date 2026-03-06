import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maret/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  final userEmail = 'admin@maret.com'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    if (email != null && email.isNotEmpty) {
      userEmail.value = email;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');
    Get.offAllNamed(Routes.LOGIN);
  }
}
