import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/area_model.dart';

class AreaController extends GetxController {
  var areas = <AreaModel>[].obs;
  var filteredAreas = <AreaModel>[].obs;
  var isLoading = false.obs;

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

  void fetchAreas() {
    isLoading.value = true;
    // Dummy data based on screenshot
    var dummyData = [
      AreaModel(id: 1, namaArea: 'HO', deskripsi: 'HO'),
      AreaModel(id: 2, namaArea: 'Pabrik Garam Sulawesi', deskripsi: ''),
      AreaModel(id: 3, namaArea: 'Kantor PKBM ISESW', deskripsi: 'Area kantor PKBM ISESW'),
      AreaModel(id: 4, namaArea: 'Kantor PKBM Isesw', deskripsi: ''),
    ];
    
    areas.assignAll(dummyData);
    filteredAreas.assignAll(dummyData);
    isLoading.value = false;
  }

  void searchArea(String query) {
    if (query.isEmpty) {
      filteredAreas.assignAll(areas);
    } else {
      filteredAreas.assignAll(areas.where((area) {
        return (area.namaArea?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (area.deskripsi?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList());
    }
  }

  void setupForm([AreaModel? area]) {
    if (area != null) {
      namaAreaController.text = area.namaArea ?? '';
      deskripsiController.text = area.deskripsi ?? '';
    } else {
      namaAreaController.clear();
      deskripsiController.clear();
    }
  }

  void saveArea([int? id]) {
    if (namaAreaController.text.isEmpty) {
      Get.snackbar('Error', 'Nama Area wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (id == null) {
        // Add new (dummy)
        final newArea = AreaModel(
          id: areas.length + 1,
          namaArea: namaAreaController.text,
          deskripsi: deskripsiController.text,
        );
        areas.add(newArea);
        Get.back();
        Get.snackbar('Sukses', 'Area berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Edit existing (dummy)
        int index = areas.indexWhere((element) => element.id == id);
        if (index != -1) {
          areas[index].namaArea = namaAreaController.text;
          areas[index].deskripsi = deskripsiController.text;
          areas.refresh();
        }
        Get.back();
        Get.snackbar('Sukses', 'Area berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      
      searchArea(searchController.text);
      isLoading.value = false;
    });
  }

  void deleteArea(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Hapus Area', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus area ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              areas.removeWhere((element) => element.id == id);
              searchArea(searchController.text);
              Get.back();
              Get.snackbar('Sukses', 'Area berhasil dihapus',
                  backgroundColor: Colors.green, colorText: Colors.white);
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
    searchController.dispose();
    namaAreaController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}
