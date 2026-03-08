import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_sop/app/routes/app_pages.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  final userEmail = 'admin@maret.com'.obs;
  final userName = 'haris'.obs;
  final isAdmin = true.obs; 


  // Dummy Dashboard Stats
  final totalSop = 12.obs;
  final activeSop = 12.obs;
  final langkahSop = 3.obs;
  final totalKategori = 6.obs;
  final pelaksanaanBulanIni = 0.obs;
  final totalPoin = 0.obs;
  final penggunaAktif = 24.obs;
  final totalPenugasan = 3.obs;

  // Chart Labels (simplified)
  final chartDays = ['01 Mar', '02 Mar', '03 Mar', '04 Mar', '05 Mar', '06 Mar', '07 Mar'].obs;
  final frequencyData = [
    {'label': 'Harian', 'value': 0.8, 'color': Color(0xFF6A11CB)},
    {'label': 'Mingguan', 'value': 0.4, 'color': Color(0xFFFFA000)},
    {'label': 'Bulanan', 'value': 0.6, 'color': Color(0xFF00C853)},
    {'label': 'Tahunan', 'value': 0.2, 'color': Color(0xFF2575FC)},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    String? name = prefs.getString('user_name');
    int? levelId = prefs.getInt('level_id');
    
    if (email != null) {
      userEmail.value = email;
    }
    
    if (name != null) {
      userName.value = name;
    }

    // Role detection: 1 = Admin, others (like 2) = Non-Admin/Staff
    if (levelId != null) {
      isAdmin.value = (levelId == 1);
    } else {
      // Fallback for safety - checking email if level_id is missing
      isAdmin.value = !(email?.contains('karyawan') ?? false);
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void logout() async {
    ConfirmDialog.show(
      title: 'Konfirmasi Keluar',
      message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      confirmText: 'Ya, Keluar',
      confirmColor: Colors.blue, // Match login theme or keep standard
      icon: Icons.logout,
      onConfirm: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('user_email');
        await prefs.remove('user_name');
        await prefs.remove('level_id');
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}
