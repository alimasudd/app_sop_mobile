import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/modules/users/controllers/users_controller.dart';

class UserFormView extends GetView<UsersController> {
  final UserModel? user;
  const UserFormView({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          user == null ? 'Tambah User' : 'Edit Staf',
          style: const TextStyle(color: Color(0xFF343A40), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Nama'),
                _buildStyledTextField(
                  controller: controller.namaController,
                  hintText: '',
                  fillColor: Colors.white,
                ),
                const SizedBox(height: 16),

                _buildLabel('Email'),
                _buildStyledTextField(
                  controller: controller.emailController,
                  hintText: 'harisk@gmail.com',
                  fillColor: const Color(0xFFE9F0FF),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                _buildLabel('Level'),
                _buildStyledDropdown<int>(
                  value: controller.selectedLevelId.value,
                  hintText: '-- Pilih Level --',
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Admin')),
                    DropdownMenuItem(value: 2, child: Text('User')),
                    DropdownMenuItem(value: 5, child: Text('Staff')),
                  ],
                  onChanged: (val) => controller.selectedLevelId.value = val,
                ),
                const SizedBox(height: 16),

                _buildLabel('Jabatan'),
                _buildStyledDropdown<String>(
                  value: controller.jabatanController.text.isEmpty ? null : controller.jabatanController.text,
                  hintText: '-',
                  items: const [
                    DropdownMenuItem(value: 'Staff IT', child: Text('Staff IT')),
                    DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                    DropdownMenuItem(value: 'Admin Keuangan', child: Text('Admin Keuangan')),
                  ],
                  onChanged: (val) => controller.jabatanController.text = val ?? '',
                ),
                const SizedBox(height: 16),

                _buildLabel(user == null ? 'Password' : 'Password (Kosongkan jika tidak ubah)'),
                _buildStyledTextField(
                  controller: controller.passwordController,
                  hintText: '********',
                  fillColor: const Color(0xFFE9F0FF),
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                _buildLabel('No HP'),
                _buildStyledTextField(
                  controller: controller.hpController,
                  hintText: '',
                  fillColor: Colors.white,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                _buildLabel('Status'),
                _buildStyledDropdown<int>(
                  value: controller.selectedStatusAktif.value,
                  hintText: 'Pilih Status',
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Aktif')),
                    DropdownMenuItem(value: 0, child: Text('Tidak Aktif')),
                  ],
                  onChanged: (val) => controller.selectedStatusAktif.value = val ?? 1,
                ),
                const SizedBox(height: 100), // Space for buttons
              ],
            ),
          )),
          
          // Action Buttons at Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   // Batal Button
                  TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Get.back();
                    },
                    child: const Text('Batal', style: TextStyle(color: Color(0xFF495057))),
                  ),
                  const SizedBox(width: 12),
                  // Update/Simpan Button
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.saveUser(user?.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4EAA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(user == null ? 'SIMPAN' : 'UPDATE', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    required Color fillColor,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE2E5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Color(0xFF495057)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStyledDropdown<T>({
    required T? value,
    required String hintText,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE2E5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hintText, style: const TextStyle(color: Color(0xFFADB5BD), fontSize: 14)),
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF495057)),
        ),
      ),
    );
  }
}
