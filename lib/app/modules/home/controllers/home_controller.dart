import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maret/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  final userEmail = 'admin@maret.com'.obs;
  final userName = 'haris'.obs;

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
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    if (email != null && email.isNotEmpty) {
      userEmail.value = email;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void logout() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('user_email');
              Get.offAllNamed(Routes.LOGIN);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
