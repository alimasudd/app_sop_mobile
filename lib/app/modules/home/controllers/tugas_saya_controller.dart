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
  final jadwalPelaksanaan = [].obs;

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
      
      if (data.containsKey('jadwal_pelaksanaan')) {
        jadwalPelaksanaan.value = data['jadwal_pelaksanaan'] as List<dynamic>;
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
    TextEditingController desController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF10B981), // Emerald Green
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Selesaikan Langkah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Pelaksanaan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: desController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tulis catatan pelaksanaan...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'URL Bukti (foto/video)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'https://...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back(); // close dialog
                        
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
                      icon: const Icon(Icons.check, color: Colors.white, size: 18),
                      label: const Text(
                        'Selesaikan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }
}
