import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/kategori_sop_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class KategoriSopController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var kategoriSops = <KategoriSopModel>[].obs;
  var isLoading = false.obs;

  // Search
  final searchController = TextEditingController();

  // Form Controllers
  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  var selectedStatus = 'aktif'.obs;

  // Detail SOP List
  var selectedKategoriName = ''.obs;
  var detailSops = <SopModel>[].obs;
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategoriSops();
  }

  Future<void> fetchKategoriSops({String? query}) async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getKategoriSops(search: query);
      kategoriSops.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori SOP: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch Kategori Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchKategori(String query) {
    fetchKategoriSops(query: query);
  }

  void setupForm([KategoriSopModel? kategori]) {
    if (kategori != null) {
      kodeController.text = kategori.kode ?? '';
      namaController.text = kategori.nama ?? '';
      deskripsiController.text = kategori.deskripsi ?? '';
      selectedStatus.value = kategori.status ?? 'aktif';
    } else {
      kodeController.clear();
      namaController.clear();
      deskripsiController.clear();
      selectedStatus.value = 'aktif';
    }
  }

  Future<void> saveKategori([int? id]) async {
    if (kodeController.text.isEmpty || namaController.text.isEmpty) {
      Get.snackbar('Error', 'Kode dan Nama wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final data = KategoriSopModel(
        kode: kodeController.text,
        nama: namaController.text,
        deskripsi: deskripsiController.text,
        status: selectedStatus.value,
      );

      if (id == null) {
        await _apiProvider.createKategoriSop(data);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Kategori SOP berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.updateKategoriSop(id, data);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Kategori SOP berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchKategoriSops(query: searchController.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan kategori: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save Kategori Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteKategori(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Hapus Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              try {
                await _apiProvider.deleteKategoriSop(id);
                Get.snackbar('Sukses', 'Kategori berhasil dihapus',
                    backgroundColor: Colors.green, colorText: Colors.white);
                fetchKategoriSops(query: searchController.text);
              } catch (e) {
                Get.snackbar('Error', 'Gagal menghapus kategori: $e',
                    backgroundColor: Colors.red, colorText: Colors.white);
              } finally {
                isLoading.value = false;
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchSopsByCategory(int categoryId) async {
    isLoadingDetail.value = true;
    detailSops.clear();
    try {
      final response = await _apiProvider.getSopsByCategory(categoryId);
      if (response['success'] == true) {
        selectedKategoriName.value = response['data']['nama_kategori'] ?? '';
        List sopsData = response['data']['sops'] ?? [];
        detailSops.assignAll(sopsData.map((e) => SopModel.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint('Fetch Detail SOP Error: $e');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
