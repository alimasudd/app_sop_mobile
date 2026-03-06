import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/modules/home/controllers/home_controller.dart';
import 'package:test_maret/app/modules/users/views/users_view.dart';
import 'package:test_maret/app/modules/users/bindings/users_binding.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We manually inject UsersBinding if we want UsersView to work inside Home
    // Ideally, we'd use a nested navigator or separate state, but for a 
    // basic layout, we can lazyPut it here or ensure it's in the binding.
    if (!Get.isRegistered<UsersBinding>()) {
      UsersBinding().dependencies(); 
    }

    return Scaffold(
      drawer: _buildSidebar(),
      appBar: AppBar(
        title: Obx(() => Text(_getTitle(controller.selectedIndex.value))),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
      ),
      body: Obx(() => _buildBody(controller.selectedIndex.value)),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(0, Icons.dashboard_outlined, 'Dashboard'),
                _buildMenuItem(1, Icons.people_outline, 'Manajemen User'),
                _buildMenuItem(2, Icons.assignment_outlined, 'Monitor Tugas'),
                _buildMenuItem(3, Icons.bar_chart_outlined, 'Laporan'),
                _buildMenuItem(4, Icons.settings_outlined, 'Pengaturan'),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Keluar', style: TextStyle(color: Colors.red)),
                  onTap: () => controller.logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Panel Admin',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'admin@maret.com',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF2575FC) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2575FC) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: const Color(0xFF2575FC).withOpacity(0.1),
        onTap: () {
          controller.changeIndex(index);
          Get.back(); // Close drawer
        },
      );
    });
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return _buildPlaceholder('Ringkasan Dashboard');
      case 1:
        // Use UsersView content directly. 
        // Since UsersView is a Scaffold, we might want to extract its body,
        // but for now, we'll return its internal structure.
        return const UsersView();
      case 2:
        return _buildPlaceholder('Halaman Monitor Tugas');
      case 3:
        return _buildPlaceholder('Laporan & Analitik');
      case 4:
        return _buildPlaceholder('Pengaturan Sistem');
      default:
        return _buildPlaceholder('Halaman Tidak Ditemukan');
    }
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 22, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Fitur ini akan segera hadir.',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0: return 'Dashboard';
      case 1: return 'Manajemen User';
      case 2: return 'Monitor Tugas';
      case 3: return 'Laporan';
      case 4: return 'Pengaturan';
      default: return 'Panel Admin';
    }
  }
}
