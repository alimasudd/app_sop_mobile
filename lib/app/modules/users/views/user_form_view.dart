import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/data/models/user_model.dart';
import 'package:test_maret/app/modules/users/controllers/users_controller.dart';

class UserFormView extends GetView<UsersController> {
  final UserModel? user;
  const UserFormView({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(user == null ? 'Tambah User' : 'Edit User'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(
                    controller: controller.namaController,
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'Alamat Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.hpController,
                    label: 'Nomor HP',
                    icon: Icons.phone_android_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<int>(
                    label: 'Level',
                    value: [1, 2, 5].contains(controller.selectedLevelId.value) 
                        ? controller.selectedLevelId.value 
                        : 2, // Default to 2 if current value is unknown
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Admin')),
                      DropdownMenuItem(value: 2, child: Text('User')),
                      DropdownMenuItem(value: 5, child: Text('Staff')),
                    ],
                    onChanged: (val) => controller.selectedLevelId.value = val!,
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown<int>(
                    label: 'Status',
                    value: [0, 1].contains(controller.selectedStatusAktif.value)
                        ? controller.selectedStatusAktif.value
                        : 1, // Default to 1 (Active)
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Aktif')),
                      DropdownMenuItem(value: 0, child: Text('Nonaktif')),
                    ],
                    onChanged: (val) => controller.selectedStatusAktif.value = val!,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.saveUser(user?.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2575FC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              user == null ? 'SIMPAN USER' : 'UPDATE USER',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2575FC)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF2575FC), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
