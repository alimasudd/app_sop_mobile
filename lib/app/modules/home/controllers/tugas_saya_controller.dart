import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class TugasSayaController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Tabs
  final selectedTab = 0.obs;

  // Data from API
  final summaryData = {}.obs;
  final tugasHariIni = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTugasData();
  }

  Future<void> fetchTugasData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await _apiProvider.getTugasKaryawan();
      
      if (data.containsKey('summary')) {
        summaryData.value = data['summary'] as Map<String, dynamic>;
      }
      
      if (data.containsKey('tugas_hari_ini')) {
        tugasHariIni.value = data['tugas_hari_ini'] as List<dynamic>;
      }
    } catch (e) {
      errorMessage('Gagal memuat tugas: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void ubahTab(int index) {
    selectedTab.value = index;
  }

  Future<void> mulaiTugas(int langkahId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      await _apiProvider.mulaiTugasKaryawan(langkahId);
      Get.back(); // cloase loading
      
      Get.snackbar(
        'Berhasil', 
        'Tugas berhasil dimulai!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
      // refresh data
      fetchTugasData();
    } catch (e) {
      Get.back(); // cloase loading
      Get.snackbar(
        'Gagal', 
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> selesaikanTugas(int langkahId) async {
    // Tampilkan popup input catatan & url bukti (opsional) 
    TextEditingController desController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Selesaikan Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Apakah Anda yakin ingin menyelesaikan langkah ini? Anda dapat menambahkan catatan opsional dan bukti penyelesaian.'),
            const SizedBox(height: 16),
            TextField(
              controller: desController,
              decoration: const InputDecoration(
                labelText: 'Catatan (Opsional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'URL Bukti (Opsional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () async {
              Get.back(); // tutup popup konfirmasi
              
              try {
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                
                await _apiProvider.selesaiTugasKaryawan(
                  langkahId, 
                  des: desController.text.isNotEmpty ? desController.text : null,
                  url: urlController.text.isNotEmpty ? urlController.text : null,
                );
                
                Get.back(); // close loading
                Get.snackbar(
                  'Berhasil', 
                  'Tugas berhasil diselesaikan!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                
                fetchTugasData();
              } catch (e) {
                Get.back(); // close loading
                Get.snackbar(
                  'Gagal', 
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
            child: const Text('Selesai', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }
}
