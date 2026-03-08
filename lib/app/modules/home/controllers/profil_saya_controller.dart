import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilSayaController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  // Text Controllers
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfilData();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> fetchProfilData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await _apiProvider.getProfilKaryawan();
      
      userData.value = data;
      
      // Init controllers
      namaController.text = data['nama'] ?? '';
      emailController.text = data['email'] ?? '';
      hpController.text = data['hp'] ?? '';
      
    } catch (e) {
      errorMessage('Gagal memuat profil: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfil() async {
    // Validasi basic
    if (namaController.text.isEmpty) {
      Get.snackbar('Error', 'Nama lengkap wajib diisi!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (hpController.text.isEmpty) {
      Get.snackbar('Error', 'Nomor WhatsApp wajib diisi!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordController.text.isNotEmpty) {
      if (passwordController.text.length < 6) {
        Get.snackbar('Error', 'Password baru minimal harus 6 karakter!', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Konfirmasi password baru tidak sesuai!', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }

    try {
      isSaving(true);
      await _apiProvider.updateProfilKaryawan(
        namaController.text, 
        hpController.text,
        password: passwordController.text.isNotEmpty ? passwordController.text : null,
        passwordConfirmation: confirmPasswordController.text.isNotEmpty ? confirmPasswordController.text : null,
      );

      // Update local storage jika nama berubah agar nyambung di sidebar main
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) {
        Map<String, dynamic> userPref = jsonDecode(userStr);
        userPref['nama'] = namaController.text;
        await prefs.setString('user', jsonEncode(userPref));
      }

      Get.snackbar('Sukses', 'Profil berhasil diperbarui!', backgroundColor: Colors.green, colorText: Colors.white);
      
      // Kosongkan form password setelah berhasil simpan
      passwordController.clear();
      confirmPasswordController.clear();
      
      fetchProfilData(); // update state ui
    } catch (e) {
      Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving(false);
    }
  }
}
