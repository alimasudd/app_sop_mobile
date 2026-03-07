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
        foregroundColor: Colors.white,
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
                
                // Master Data Sub-menu
                _buildExpansionMenu(
                  title: 'Master Data',
                  icon: Icons.storage,
                  items: [
                    // Nested Area (Level 3)
                    Theme(
                      data: Get.theme.copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.only(left: 32, right: 16),
                        leading: Icon(Icons.map_outlined, size: 20, color: Colors.grey[600]),
                        title: Text('Area', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                        iconColor: const Color(0xFF2575FC),
                        collapsedIconColor: Colors.grey[600],
                        children: [
                          _buildSubMenuItem(101, Icons.list_alt_outlined, 'Daftar Area', leftPadding: 48),
                          _buildSubMenuItem(102, Icons.category_outlined, 'Tipe Area', leftPadding: 48),
                        ],
                      ),
                    ),
                    _buildSubMenuItem(11, Icons.business_outlined, 'Ruang'),
                    _buildSubMenuItem(12, Icons.folder_outlined, 'Kategori SOP'),
                    _buildSubMenuItem(13, Icons.description_outlined, 'SOP'),
                    _buildSubMenuItem(14, Icons.format_list_numbered_outlined, 'Langkah SOP'),
                    _buildSubMenuItem(15, Icons.person_add_outlined, 'Tugas SOP'),
                    _buildSubMenuItem(16, Icons.check_box_outlined, 'Pelaksanaan SOP'),
                  ],
                ),

                // Report Sub-menu
                _buildExpansionMenu(
                  title: 'Report',
                  icon: Icons.article_outlined,
                  items: [
                    _buildSubMenuItem(20, Icons.bar_chart_outlined, 'Laporan SOP'),
                    _buildSubMenuItem(21, Icons.group_outlined, 'Laporan Karyawan'),
                  ],
                ),

                _buildMenuItem(4, Icons.settings_outlined, 'Setting'),
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

  Widget _buildExpansionMenu({required String title, required IconData icon, required List<Widget> items}) {
    return Theme(
      data: Get.theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconColor: const Color(0xFF2575FC),
        collapsedIconColor: Colors.grey[700],
        children: items,
      ),
    );
  }

  Widget _buildSubMenuItem(int index, IconData icon, String title, {double leftPadding = 32}) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return ListTile(
        contentPadding: EdgeInsets.only(left: leftPadding),
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF2575FC) : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2575FC) : Colors.black87,
            fontSize: 14,
          ),
        ),
        onTap: () {
          controller.changeIndex(index);
          Get.back();
        },
      );
    });
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
          Obx(() => Text(
            controller.userEmail.value,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          )),
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
          color: isSelected ? const Color(0xFF2575FC) : Colors.grey[700],
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
      case 0: return _buildPlaceholder('Ringkasan Dashboard');
      case 1: return const UsersView();
      case 101: return _buildPlaceholder('Master: Daftar Area');
      case 102: return _buildPlaceholder('Master: Tipe Area');
      case 11: return _buildPlaceholder('Data Master: Ruang');
      case 12: return _buildPlaceholder('Data Master: Kategori SOP');
      case 13: return _buildPlaceholder('Data Master: SOP');
      case 14: return _buildPlaceholder('Data Master: Langkah SOP');
      case 15: return _buildPlaceholder('Data Master: Tugas SOP');
      case 16: return _buildPlaceholder('Data Master: Pelaksanaan SOP');
      case 20: return _buildPlaceholder('Laporan SOP');
      case 21: return _buildPlaceholder('Laporan Karyawan');
      case 4: return _buildPlaceholder('Pengaturan Sistem');
      default: return _buildPlaceholder('Halaman Baru Sedang Disiapkan');
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
      case 101: return 'Master: Daftar Area';
      case 102: return 'Master: Tipe Area';
      case 11: return 'Master: Ruang';
      case 12: return 'Master: Kategori SOP';
      case 13: return 'Master: SOP';
      case 14: return 'Master: Langkah SOP';
      case 15: return 'Master: Tugas SOP';
      case 16: return 'Master: Pelaksanaan SOP';
      case 20: return 'Laporan SOP';
      case 21: return 'Laporan Karyawan';
      case 4: return 'Pengaturan';
      default: return 'Panel Admin';
    }
  }
}
