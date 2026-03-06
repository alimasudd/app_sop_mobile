import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Akun Baru', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blueAccent),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lengkapi Data Diri',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF242B42)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pastikan data yang diisi benar sesuai KTP.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // NIK
              _buildModernTextField(
                controller: controller.regNikController,
                hintText: 'NIK',
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const Divider(height: 1, color: Colors.grey),
              
              // Nama Lengkap
              _buildModernTextField(
                controller: controller.regNamaController,
                hintText: 'Nama Lengkap',
              ),
              const Divider(height: 1, color: Colors.grey),
              
              // Nomor HP
              _buildModernTextField(
                controller: controller.regHpController,
                hintText: 'Nomor HP / WhatsApp',
                keyboardType: TextInputType.phone,
              ),
              const Divider(height: 1, color: Colors.grey),
              
              // Email (Standard blue-ish box style from image)
              const SizedBox(height: 10),
              _buildBoxedTextField(
                controller: controller.regEmailController,
                hintText: 'harisk@gmail.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),
              
              // Password
              _buildBoxedTextField(
                controller: controller.regPasswordController,
                hintText: '*********',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 40),
              
              // Register Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.register(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5BD0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'DAFTAR SEKARANG',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              )),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                   'Sudah punya akun? Masuk',
                   style: TextStyle(color: Color(0xFF2D5BD0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Linear field style for top fields
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          counterText: "",
        ),
      ),
    );
  }

  // Boxed style for email/password fields
  Widget _buildBoxedTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.blueAccent.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}
