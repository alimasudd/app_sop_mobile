import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_maret/app/data/providers/api_provider.dart';
import 'package:test_maret/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();

  final isLoading = false.obs;

  // Controllers for Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controllers for Register
  final regNamaController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
  final regHpController = TextEditingController();

  void login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.login(
        loginEmailController.text,
        loginPasswordController.text,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Assuming the API returns token in 'token' or 'data.token'
        String token = data['token'] ?? data['data']?['token'];
        if (token != null) {
          _storage.write('token', token);
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar('Success', 'Login successful, but no token received.',
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', data['message'] ?? 'Login failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    if (regNamaController.text.isEmpty ||
        regEmailController.text.isEmpty ||
        regPasswordController.text.isEmpty ||
        regHpController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.register({
        'nama': regNamaController.text,
        'email': regEmailController.text,
        'password': regPasswordController.text,
        'hp': regHpController.text,
        'level_id': 2, // Default level
        'status_aktif': 1, // Default status
      });

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Account created successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back(); // Go back to login
      } else {
        Get.snackbar('Error', data['message'] ?? 'Registration failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regNamaController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regHpController.dispose();
    super.onClose();
  }
}
