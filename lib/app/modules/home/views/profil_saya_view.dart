import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/profil_saya_controller.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';

class ProfilSayaView extends StatelessWidget {
  const ProfilSayaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfilSayaController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background like in image
      body: Obx(() {
        if (controller.isLoading.value && controller.userData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.userData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProfilData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final user = controller.userData;

        return RefreshIndicator(
          onRefresh: controller.fetchProfilData,
          color: const Color(0xFF6A11CB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Column Web Style - Identitas Ringkas
                _buildProfileCard(user),
                const SizedBox(height: 16),
                
                // Left Column Web Style - Informasi Warning
                _buildInfoCard(),
                const SizedBox(height: 24),
                
                // Right Column Web Style - Edit Form
                _buildEditFormCard(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(Map user) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          children: [
            // Avatar 
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!, width: 4),
                color: Colors.grey[100],
              ),
              child: const Icon(Icons.person, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Nama & Jabatan
            Text(
              user['nama'] ?? 'Karyawan',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.work_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  user['jabatan'] ?? 'Security',
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            
            // Email detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.email, size: 16, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Text(
                  user['email'] ?? '-',
                  style: const TextStyle(color: Color(0xFF0ea5e9), fontSize: 13), // blue text
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // WhatsApp detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.phone_android, size: 16, color: Colors.green), // custom wa icon equivalent
                    SizedBox(width: 8),
                    Text('No. WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Text(
                  user['hp'] ?? '-',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Status detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.green),
                    SizedBox(width: 10),
                    Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Text(
                  user['status'] ?? 'Aktif',
                  style: const TextStyle(color: Color(0xFF0ea5e9), fontSize: 13),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF0ea5e9), width: 1.5), // Blue border like web
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.black87, size: 18),
                SizedBox(width: 8),
                Text('Informasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
                children: [
                  WidgetSpan(child: Icon(Icons.phone_android, size: 14, color: Colors.green)),
                  TextSpan(text: ' Nomor WhatsApp ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  TextSpan(text: 'digunakan untuk menerima '),
                  TextSpan(text: 'reminder otomatis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  TextSpan(text: ' terkait tugas SOP yang ditugaskan kepada Anda.'),
                ]
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
                children: [
                  WidgetSpan(child: Icon(Icons.error, size: 14, color: Colors.brown)),
                  TextSpan(text: ' Pastikan nomor WhatsApp yang Anda masukkan adalah '),
                  TextSpan(text: 'nomor yang aktif', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  TextSpan(text: ' dan terdaftar di WhatsApp.'),
                ]
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Color(0xFF0ea5e9)),
                const SizedBox(width: 4),
                const Text('Format nomor: ', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                  child: Text('08xxxxxxxxxx', style: TextStyle(color: Colors.red[400], fontSize: 11)),
                ),
                const Text(' atau ', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                  child: Text('628xxxxxxxxxx', style: TextStyle(color: Colors.red[400], fontSize: 11)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditFormCard(ProfilSayaController controller) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_square, size: 20, color: Colors.black87),
                SizedBox(width: 8),
                Text('Edit Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Nama Lengkap
            _buildTextField(
              label: 'Nama Lengkap',
              controller: controller.namaController,
              icon: Icons.person,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            
            // Email (disabled)
            _buildTextField(
              label: 'Email',
              controller: controller.emailController,
              icon: Icons.email,
              enabled: false,
              helperText: 'Email tidak dapat diubah. Hubungi Admin jika perlu perubahan.',
            ),
            const SizedBox(height: 16),
            
            // WhatsApp (Green theme per web)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Nomor WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ]
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.hpController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4, left: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366), // WA Green
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.phone_android, size: 20, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      borderSide: const BorderSide(color: Color(0xFF25D366), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Masukkan nomor HP aktif yang terdaftar di WhatsApp.', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),
            
            const Divider(color: Color(0xFFEEEEEE), thickness: 1.5),
            const SizedBox(height: 24),
            
            // Password Section
            const Row(
              children: [
                Icon(Icons.lock, size: 18),
                SizedBox(width: 8),
                Text('Ganti Password ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('(opsional)', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              label: 'Password Baru',
              controller: controller.passwordController,
              isPassword: true,
              hintText: 'Kosongkan jika tidak ingin mengubah password',
              helperText: 'Minimal 6 karakter. Kosongkan jika tidak ingin mengubah password.',
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              label: 'Konfirmasi Password Baru',
              controller: controller.confirmPasswordController,
              isPassword: true,
              hintText: 'Ketik ulang password baru',
            ),
            const SizedBox(height: 32),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A), // Dark blue like web
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: controller.isSaving.value ? null : controller.updateProfil,
                      icon: controller.isSaving.value 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save, size: 18, color: Colors.white),
                      label: Text(
                        controller.isSaving.value ? 'Menyimpan...' : 'SIMPAN PERUBAHAN', 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // Light grey for back button
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (Get.isRegistered<HomeController>()) {
                      Get.find<HomeController>().changeIndex(0); // Back to Dashboard
                    }
                  },
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    IconData? icon, 
    bool isPassword = false, 
    bool enabled = true,
    bool isRequired = false,
    String? hintText,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.black87),
              const SizedBox(width: 6),
            ],
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                children: [
                  if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                ]
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          enabled: enabled,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey[600],
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            fillColor: enabled ? Colors.white : Colors.grey[50], // Abu2 kl disabled
            filled: !enabled,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(helperText, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]
      ],
    );
  }
}
