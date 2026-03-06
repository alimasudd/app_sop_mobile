import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maret/app/data/providers/api_provider.dart';
import 'package:test_maret/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  // Controllers for Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controllers for Register
  final regNikController = TextEditingController();
  final regNamaController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
  final regHpController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Validation Error: Email and password are empty');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.login(
        loginEmailController.text,
        loginPasswordController.text,
      );

      final data = json.decode(response.body);
      debugPrint('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        String? token = data['token'] ?? 
                        data['access_token'] ?? 
                        data['data']?['token'] ?? 
                        data['data']?['access_token'];
        
        // Extract user email if available in response
        String? userEmail = data['user']?['email'] ?? data['data']?['user']?['email'] ?? loginEmailController.text;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('user_email', userEmail ?? '');
          
          if (rememberMe.value) {
            await prefs.setString('remember_email', loginEmailController.text);
          } else {
            await prefs.remove('remember_email');
          }
          
          Get.offAllNamed(Routes.HOME);
        } else {
          print('DEBUG: Token missing in response. Data was: $data');
          Get.snackbar('Token Tidak Ditemukan', 'Isi Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}',
              backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 10));
        }
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Login gagal',
            backgroundColor: Colors.red, colorText: Colors.white);
        debugPrint('Login API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Login Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    if (regNikController.text.length != 16) {
      Get.snackbar('Error', 'NIK harus 16 digit',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Validation Error: NIK length is ${regNikController.text.length}, expected 16');
      return;
    }

    if (regNamaController.text.isEmpty ||
        regEmailController.text.isEmpty ||
        regPasswordController.text.isEmpty ||
        regHpController.text.isEmpty) {
      Get.snackbar('Error', 'Semua kolom wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Validation Error: Registration fields are incomplete');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.register({
        'nik': regNikController.text,
        'nama': regNamaController.text,
        'email': regEmailController.text,
        'password': regPasswordController.text,
        'hp': regHpController.text,
        'level_id': 2,
        'status_aktif': 1,
      });

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Sukses', 'Akun berhasil dibuat, silakan login',
            backgroundColor: Colors.green, colorText: Colors.white);
        debugPrint('Registration Success');
        
        // Return to login page
        Get.offAllNamed(Routes.LOGIN); 
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Registrasi gagal',
            backgroundColor: Colors.red, colorText: Colors.white);
        debugPrint('Registration API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Registration Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void testApi() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.checkHealth();
      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Berhasil terhubung ke server API!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Server terdeteksi tapi error: ${response.statusCode}',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi API: $e',
          backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadRememberedEmail();
  }

  void _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? rememberedEmail = prefs.getString('remember_email');
    if (rememberedEmail != null) {
      loginEmailController.text = rememberedEmail;
      rememberMe.value = true;
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regNikController.dispose();
    regNamaController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regHpController.dispose();
    super.onClose();
  }
}
