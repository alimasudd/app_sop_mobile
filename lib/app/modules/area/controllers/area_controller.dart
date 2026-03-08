import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';

class AreaController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var areas = <AreaModel>[].obs;
  var isLoading = false.obs;
  var perPage = 10.obs;

  // Search
  final searchController = TextEditingController();

  // Form Controllers
  final namaAreaController = TextEditingController();
  final deskripsiController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAreas();
  }

  Future<void> fetchAreas({String? query}) async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getAreas(search: query, perPage: perPage.value);
      areas.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat area: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch Areas Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchArea(String query) {
    // Basic debounce could be added here, but for now just call fetch
    fetchAreas(query: query);
  }

  void setupForm([AreaModel? area]) {
    if (area != null) {
      namaAreaController.text = area.nama ?? '';
      deskripsiController.text = area.des ?? '';
    } else {
      namaAreaController.clear();
      deskripsiController.clear();
    }
  }

  Future<void> saveArea([int? id]) async {
    debugPrint('saveArea called with id: $id');
    if (namaAreaController.text.isEmpty) {
      Get.snackbar('Error', 'Nama Area wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final areaData = AreaModel(
        nama: namaAreaController.text,
        des: deskripsiController.text,
      );

      if (id == null) {
        await _apiProvider.createArea(areaData);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Area berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.updateArea(id, areaData);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Sukses', 'Area berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchAreas(query: searchController.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan area: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save Area Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteArea(int id) {
    ConfirmDialog.show(
      title: 'Hapus Area',
      message: 'Apakah Anda yakin ingin menghapus area ini?',
      icon: Icons.delete_sweep,
      onConfirm: () async {
        isLoading.value = true;
        try {
          await _apiProvider.deleteArea(id);
          Get.snackbar('Sukses', 'Area berhasil dihapus',
              backgroundColor: Colors.green, colorText: Colors.white);
          fetchAreas(query: searchController.text);
        } catch (e) {
          Get.snackbar('Error', 'Gagal menghapus area: $e',
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint('Delete Area Error: $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
