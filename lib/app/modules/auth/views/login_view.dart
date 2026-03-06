import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/routes/app_pages.dart';
import 'package:test_maret/app/modules/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder - Using a generic Icon since we can't easily embed local artifact path in runtime asset system
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    size: 60,
                    color: Color(0xFF2D5BD0),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Manajemen SOP',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF242B42),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Silahkan masuk untuk memulai sesi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7E8494),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Email Field
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.loginEmailController,
                  hintText: 'user@gmail.com',
                  suffixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                
                // Password Field
                _buildLabel('Password'),
                const SizedBox(height: 8),
                Obx(() => _buildTextField(
                  controller: controller.loginPasswordController,
                  hintText: '*********',
                  isPassword: true,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: controller.isPasswordVisible.value 
                      ? Icons.visibility_off_outlined 
                      : Icons.visibility_outlined,
                  onSuffixTap: () => controller.togglePasswordVisibility(),
                )),
                const SizedBox(height: 20),
                
                // Remember & Forgot
                Row(
                  children: [
                    Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (val) => controller.rememberMe.value = val!,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      activeColor: const Color(0xFF2D5BD0),
                    )),
                    const Text('Ingat Saya', style: TextStyle(color: Color(0xFF7E8494))),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(color: Color(0xFF2D5BD0), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5BD0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF2D5BD0).withOpacity(0.4),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.login_rounded, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'MASUK',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                  ),
                )),
                const SizedBox(height: 30),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('ATAU', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person_add_outlined, size: 20, color: Color(0xFF242B42)),
                        SizedBox(width: 10),
                        Text(
                          'Daftar Akun Baru',
                          style: TextStyle(color: Color(0xFF242B42), fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Test Connection Button (Keep for debugging as requested before)
                TextButton(
                  onPressed: () => controller.testApi(),
                  child: const Text('Cek Koneksi Server', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF242B42),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? suffixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Color(0xFF242B42)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF7E8494)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: suffixIcon != null 
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: const Color(0xFF7E8494)),
              )
            : null,
        ),
      ),
    );
  }
}
