import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      appBar: AppBar(
        title: const Text('Daftar Akun Baru', style: TextStyle(color: Color(0xFF242B42), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D5BD0)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/icons/sop.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF242B42)),
                ),
                const SizedBox(height: 8),
                const Text('Silakan lengkapi data diri Anda', style: TextStyle(color: Color(0xFF7E8494))),
                const SizedBox(height: 30),

                _buildLabel('NIK (16 Digit)'),
                const SizedBox(height: 8),
                _buildField(
                  controller: controller.regNikController,
                  hintText: 'Masukkan 16 digit NIK',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),

                _buildLabel('Nama Lengkap'),
                const SizedBox(height: 8),
                _buildField(
                  controller: controller.regNamaController,
                  hintText: 'Nama Lengkap Anda',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 15),

                _buildLabel('Nomor HP / WhatsApp'),
                const SizedBox(height: 8),
                _buildField(
                  controller: controller.regHpController,
                  hintText: '0812xxxx',
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildField(
                  controller: controller.regEmailController,
                  hintText: 'user@gmail.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

                _buildLabel('Password'),
                const SizedBox(height: 8),
                _buildField(
                  controller: controller.regPasswordController,
                  hintText: '*********',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

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
                      elevation: 4,
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
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Sudah punya akun? Masuk',
                    style: TextStyle(color: Color(0xFF2D5BD0)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF242B42)),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF7E8494)),
          prefixIcon: Icon(icon, color: const Color(0xFF2D5BD0).withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
