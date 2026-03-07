import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/data/models/area_model.dart';

class RuangController extends GetxController {
  var rooms = <RuangModel>[].obs;
  var filteredRooms = <RuangModel>[].obs;
  var areas = <AreaModel>[].obs;
  var isLoading = false.obs;

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

  void fetchInitialData() {
    isLoading.value = true;
    
    // Dummy Areas
    var dummyAreas = [
      AreaModel(id: 1, namaArea: 'HO'),
      AreaModel(id: 2, namaArea: 'Pabrik Garam Sulawesi'),
      AreaModel(id: 3, namaArea: 'Kantor PKBM ISESW'),
      AreaModel(id: 4, namaArea: 'Kantor PKBM Isesw'),
    ];
    areas.assignAll(dummyAreas);

    // Dummy Rooms based on screenshot
    var dummyRooms = [
      RuangModel(id: 1, areaId: 1, namaArea: 'HO', namaRuang: 'SERVER GA', deskripsi: 'SERVER GA', createdAt: '25/02/2026 08:54'),
      RuangModel(id: 2, areaId: 4, namaArea: 'Kantor PKBM Isesw', namaRuang: 'Ruang Staf TU', deskripsi: 'Ruang kerja staf Tata Usaha', createdAt: '08/02/2026 06:29'),
      RuangModel(id: 3, areaId: 4, namaArea: 'Kantor PKBM Isesw', namaRuang: 'Ruang Kursus Komputer Tengah', deskripsi: 'Ruang untuk kursus komputer di tengah gedung', createdAt: '08/02/2026 06:29'),
    ];
    
    rooms.assignAll(dummyRooms);
    filteredRooms.assignAll(dummyRooms);
    isLoading.value = false;
  }

  void searchRoom(String query) {
    if (query.isEmpty) {
      filteredRooms.assignAll(rooms);
    } else {
      filteredRooms.assignAll(rooms.where((room) {
        return (room.namaRuang?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (room.namaArea?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (room.deskripsi?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList());
    }
  }

  void setupForm([RuangModel? room]) {
    if (room != null) {
      selectedAreaId.value = room.areaId;
      namaRuangController.text = room.namaRuang ?? '';
      deskripsiController.text = room.deskripsi ?? '';
    } else {
      selectedAreaId.value = null;
      namaRuangController.clear();
      deskripsiController.clear();
    }
  }

  void saveRoom([int? id]) {
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
    
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final area = areas.firstWhere((a) => a.id == selectedAreaId.value);
      
      if (id == null) {
        final newRoom = RuangModel(
          id: rooms.length + 1,
          areaId: selectedAreaId.value,
          namaArea: area.namaArea,
          namaRuang: namaRuangController.text,
          deskripsi: deskripsiController.text,
          createdAt: DateTime.now().toString().substring(0, 16),
        );
        rooms.add(newRoom);
        Get.back();
        Get.snackbar('Sukses', 'Ruang berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        int index = rooms.indexWhere((element) => element.id == id);
        if (index != -1) {
          rooms[index].areaId = selectedAreaId.value;
          rooms[index].namaArea = area.namaArea;
          rooms[index].namaRuang = namaRuangController.text;
          rooms[index].deskripsi = deskripsiController.text;
          rooms.refresh();
        }
        Get.back();
        Get.snackbar('Sukses', 'Ruang berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      
      searchRoom(searchController.text);
      isLoading.value = false;
    });
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
            onPressed: () {
              rooms.removeWhere((element) => element.id == id);
              searchRoom(searchController.text);
              Get.back();
              Get.snackbar('Sukses', 'Ruang berhasil dihapus',
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
    namaRuangController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}
