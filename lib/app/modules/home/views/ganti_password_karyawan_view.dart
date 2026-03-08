import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/ganti_password_karyawan_controller.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';

class GantiPasswordKaryawanView extends StatelessWidget {
  const GantiPasswordKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GantiPasswordKaryawanController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background like in image
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                    ),
                    child: const Text('Form Ganti Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  
                  // Body Card
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: 'Password Baru',
                          controller: controller.passwordController,
                          hintText: 'Masukkan password baru',
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          label: 'Ulangi Password Baru',
                          controller: controller.confirmPasswordController,
                          hintText: 'Ketik ulang password baru',
                          isPassword: true,
                        ),
                        const SizedBox(height: 32),
                        
                        // Buttons
                        Row(
                          children: [
                            Obx(() {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A), // Dark blue like web
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: controller.isSaving.value ? null : controller.gantiPassword,
                                child: controller.isSaving.value 
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text(
                                        'SIMPAN PASSWORD BARU', 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                      ),
                              );
                            }),
                            const SizedBox(width: 12),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                if (Get.isRegistered<HomeController>()) {
                                  Get.find<HomeController>().changeIndex(0); // Back to Dashboard
                                }
                              },
                              child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    bool isPassword = false, 
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6B66FF)),
            ),
          ),
        ),
      ],
    );
  }
}
