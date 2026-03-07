import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/bindings/home_binding.dart';
import 'package:app_sop/app/modules/home/views/dashboard_view.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';
import 'package:app_sop/app/modules/users/views/users_view.dart';
import 'package:app_sop/app/modules/users/bindings/users_binding.dart';
import 'package:app_sop/app/modules/area/views/area_view.dart';
import 'package:app_sop/app/modules/area/bindings/area_binding.dart';
import 'package:app_sop/app/modules/ruang/views/ruang_view.dart';
import 'package:app_sop/app/modules/ruang/bindings/ruang_binding.dart';

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
    if (!Get.isRegistered<AreaBinding>()) {
      AreaBinding().dependencies(); 
    }
    if (!Get.isRegistered<RuangBinding>()) {
      RuangBinding().dependencies(); 
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
            child: Obx(() {
              final isAdmin = controller.isAdmin.value;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(0, Icons.dashboard_outlined, 'Dashboard'),
                  
                  if (isAdmin) ...[
                    _buildMenuItem(2, Icons.visibility_outlined, 'Pengawas SOP Harian'),
                    _buildMenuItem(3, Icons.query_stats_outlined, 'Monitor Tugas'),
                    
                    _buildExpansionMenu(
                      title: 'Users',
                      icon: Icons.people_outline,
                      items: [
                        _buildSubMenuItem(51, Icons.vpn_key_outlined, 'Change Password'),
                        _buildSubMenuItem(52, Icons.person_outline, 'Admin'),
                        _buildSubMenuItem(53, Icons.security, 'Security'),
                        _buildSubMenuItem(54, Icons.brush_outlined, 'Cleaning Service'),
                        
                        // Nested Staf Expansion
                        Theme(
                          data: Get.theme.copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.only(left: 32, right: 16),
                            leading: Icon(Icons.people_outline, size: 20, color: Colors.grey[600]),
                            title: Text('Staf', style: TextStyle(color: Colors.grey[800], fontSize: 14, fontWeight: FontWeight.bold)),
                            iconColor: const Color(0xFF2575FC),
                            collapsedIconColor: Colors.grey[600],
                            children: [
                              _buildSubMenuItem(55, Icons.shopping_cart_outlined, 'Staf Toko', leftPadding: 48),
                              _buildSubMenuItem(56, Icons.person_search_outlined, 'Staf HRD', leftPadding: 48),
                            ],
                          ),
                        ),
                        
                        _buildSubMenuItem(1, Icons.people_outline, 'Semua'),
                      ],
                    ),

                    _buildExpansionMenu(
                      title: 'Master Data',
                      icon: Icons.storage,
                      items: [
                        _buildSubMenuItem(101, Icons.map_outlined, 'Area'),
                        _buildSubMenuItem(11, Icons.business_outlined, 'Ruang'),
                        _buildSubMenuItem(12, Icons.folder_outlined, 'Kategori SOP'),
                        _buildSubMenuItem(13, Icons.description_outlined, 'SOP'),
                        _buildSubMenuItem(14, Icons.format_list_numbered_outlined, 'Langkah SOP'),
                        _buildSubMenuItem(15, Icons.person_add_outlined, 'Tugas SOP'),
                        _buildSubMenuItem(16, Icons.check_box_outlined, 'Pelaksanaan SOP'),
                      ],
                    ),

                    _buildExpansionMenu(
                      title: 'Report',
                      icon: Icons.article_outlined,
                      items: [
                        _buildSubMenuItem(20, Icons.bar_chart_outlined, 'Laporan SOP'),
                        _buildSubMenuItem(21, Icons.group_outlined, 'Laporan Karyawan'),
                      ],
                    ),
                    _buildMenuItem(4, Icons.settings_outlined, 'Setting'),
                  ] else ...[
                    _buildMenuItem(5, Icons.assignment_outlined, 'Tugas Saya', badge: '1'),
                    _buildMenuItem(6, Icons.book_outlined, 'Laporan Saya'),
                    _buildMenuItem(7, Icons.account_box_outlined, 'Profil Saya'),
                    _buildMenuItem(8, Icons.vpn_key_outlined, 'Ganti Password'),
                  ],

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Keluar', style: TextStyle(color: Colors.red)),
                    onTap: () => controller.logout(),
                  ),
                ],
              );
            }),
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
          Obx(() => Text(
            controller.userName.value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )),
          Obx(() => Text(
            controller.userEmail.value,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title, {String? badge}) {
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
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            : null,
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
      case 0: return const DashboardView();
      case 1: return const UsersView();
      case 101: return const AreaView();
      case 11: return const RuangView();
      case 2: return _buildPlaceholder('Pengawas SOP Harian');
      case 3: return _buildPlaceholder('Monitor Tugas');
      case 12: return _buildPlaceholder('Master: Kategori SOP');
      case 13: return _buildPlaceholder('Master: SOP');
      case 14: return _buildPlaceholder('Master: Langkah SOP');
      case 15: return _buildPlaceholder('Master: Tugas SOP');
      case 16: return _buildPlaceholder('Master: Pelaksanaan SOP');
      case 20: return _buildPlaceholder('Laporan SOP');
      case 21: return _buildPlaceholder('Laporan Karyawan');
      case 4: return _buildPlaceholder('Pengaturan');
      // Karyawan Menus
      case 5: return _buildPlaceholder('Tugas Saya');
      case 6: return _buildPlaceholder('Laporan Saya');
      case 7: return _buildPlaceholder('Profil Saya');
      case 8: return _buildPlaceholder('Ganti Password');
      // Sub Users Menus
      case 51: return _buildPlaceholder('Change Password');
      case 52: return _buildPlaceholder('Admin Users');
      case 53: return _buildPlaceholder('Security Users');
      case 54: return _buildPlaceholder('Cleaning Service Users');
      case 55: return _buildPlaceholder('Staf Toko Users');
      case 56: return _buildPlaceholder('Staf HRD Users');
      default: return const DashboardView();
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
      case 101: return 'Manajemen Area';
      case 11: return 'Manajemen Ruang';
      case 2: return 'Pengawas SOP Harian';
      case 3: return 'Monitor Tugas';
      case 12: return 'Master: Kategori SOP';
      case 13: return 'Master: SOP';
      case 14: return 'Master: Langkah SOP';
      case 15: return 'Master: Tugas SOP';
      case 16: return 'Master: Pelaksanaan SOP';
      case 20: return 'Laporan SOP';
      case 21: return 'Laporan Karyawan';
      case 4: return 'Pengaturan';
      case 5: return 'Tugas Saya';
      case 6: return 'Laporan Saya';
      case 7: return 'Profil Saya';
      case 8: return 'Ganti Password';
      case 51: return 'Change Password';
      case 52: return 'Users: Admin';
      case 53: return 'Users: Security';
      case 54: return 'Users: Cleaning Service';
      case 55: return 'Users: Staf Toko';
      case 56: return 'Users: Staf HRD';
      default: return 'Manajemen SOP';
    }
  }
}
