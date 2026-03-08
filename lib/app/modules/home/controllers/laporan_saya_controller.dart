import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:intl/intl.dart';

class LaporanSayaController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Fitur Filter Tanggal
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Data dari API
  final summaryData = {}.obs;
  final riwayatList = [].obs;

  @override
  void onInit() {
    super.onInit();
    // Default 1 minggu terakhir, atau set ke null biar backend fallback ke 1 bulan
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month, now.day);
    fetchLaporanData();
  }

  Future<void> fetchLaporanData() async {
    try {
      isLoading(true);
      errorMessage('');
      
      String? startStr;
      String? endStr;
      
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      if (startDate.value != null && endDate.value != null) {
        startStr = formatter.format(startDate.value!);
        endStr = formatter.format(endDate.value!);
      }

      final data = await _apiProvider.getLaporanKaryawan(startDate: startStr, endDate: endStr);
      
      if (data.containsKey('summary')) {
        summaryData.value = data['summary'] as Map<String, dynamic>;
      }
      
      if (data.containsKey('riwayat')) {
        riwayatList.value = data['riwayat'] as List<dynamic>;
      }
    } catch (e) {
      errorMessage('Gagal memuat laporan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: startDate.value != null && endDate.value != null
          ? DateTimeRange(start: startDate.value!, end: endDate.value!)
          : null,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6A11CB), // Main color
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      fetchLaporanData(); // Fetch langsung kalau udah pilih
    }
  }
}
