import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_maret/app/routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  final storage = GetStorage();

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        storage.remove('token');
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}
