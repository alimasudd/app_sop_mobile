import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class RuangController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var rooms = <RuangModel>[].obs;
  var areas = <AreaModel>[].obs;
  var isLoading = false.obs;
  var perPage = 10.obs;

  // Search
  final searchController = TextEditingController();

  // Form Controllers
  final selectedAreaId = Rxn<int>();
  final namaRuangController = TextEditingController();
  final deskripsiController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      final areaData = await _apiProvider.getAreas(perPage: 100);
      areas.assignAll(areaData);
      
      final roomData = await _apiProvider.getRuangs(perPage: perPage.value);
      rooms.assignAll(roomData);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch Initial Data Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRooms({String? query}) async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getRuangs(search: query, perPage: perPage.value);
      rooms.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat ruang: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch Rooms Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchRoom(String query) {
    fetchRooms(query: query);
  }

  void setupForm([RuangModel? room]) {
    if (room != null) {
      selectedAreaId.value = room.areaId;
      namaRuangController.text = room.nama ?? '';
      deskripsiController.text = room.des ?? '';
    } else {
      selectedAreaId.value = null;
      namaRuangController.clear();
      deskripsiController.clear();
    }
  }

  Future<void> saveRoom([int? id]) async {
    debugPrint('saveRoom called with id: $id');
    if (selectedAreaId.value == null) {
      Get.snackbar('Error', 'Area wajib dipilih',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (namaRuangController.text.isEmpty) {
      Get.snackbar('Error', 'Nama Ruang wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final roomData = RuangModel(
        areaId: selectedAreaId.value,
        nama: namaRuangController.text,
        des: deskripsiController.text,
      );

      if (id == null) {
        await _apiProvider.createRuang(roomData);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Ruang berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.updateRuang(id, roomData);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Ruang berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchRooms(query: searchController.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan ruang: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save Room Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteRoom(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Hapus Ruang', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus ruang ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              try {
                await _apiProvider.deleteRuang(id);
                Get.snackbar('Sukses', 'Ruang berhasil dihapus',
                    backgroundColor: Colors.green, colorText: Colors.white);
                fetchRooms(query: searchController.text);
              } catch (e) {
                Get.snackbar('Error', 'Gagal menghapus ruang: $e',
                    backgroundColor: Colors.red, colorText: Colors.white);
                debugPrint('Delete Room Error: $e');
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

  @override
  void onClose() {
    super.onClose();
  }
}
