import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class GantiPasswordKaryawanController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isSaving = false.obs;
  
  // Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> gantiPassword() async {
    final pass = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (pass.isEmpty) {
      Get.snackbar('Error', 'Password baru wajib diisi!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (pass.length < 6) {
      Get.snackbar('Error', 'Password baru minimal harus 6 karakter!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (pass != confirm) {
      Get.snackbar('Error', 'Konfirmasi password baru tidak sesuai!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSaving(true);
      
      await _apiProvider.gantiPasswordKaryawan(pass, confirm);

      Get.snackbar('Sukses', 'Password berhasil diperbarui!', backgroundColor: Colors.green, colorText: Colors.white);
      
      // Kosongkan form setelah berhasil
      passwordController.clear();
      confirmPasswordController.clear();
      
    } catch (e) {
      Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving(false);
    }
  }
}
