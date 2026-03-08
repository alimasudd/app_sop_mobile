import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/routes/app_pages.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:app_sop/app/data/models/tugas_sop_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';

class TugasSopController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  
  var tugasSops = <TugasSopModel>[].obs;
  var isLoading = false.obs;
  var isInfoExpanded = true.obs;
  
  // Pagination & Search
  var perPage = 10.obs;
  final searchController = TextEditingController();
  
  // Dropdown data
  var sopList = <SopModel>[].obs;
  var userList = <UserModel>[].obs;
  var langkahSopList = <SopLangkahModel>[].obs;

  // Form State
  var isMassal = false.obs;
  var selectedSopId = Rxn<int>();
  var selectedUserId = Rxn<int>(); // Single
  var selectedUserIds = <int>[].obs; // Massal
  var ditugaskanPada = 'semua'.obs; // 'semua' or 'tertentu'
  var selectedLangkahId = Rxn<int>(); // The API allows array for langkah too, but UI shows single select for "Langkah Tertentu". We can send array of 1.

  @override
  void onInit() {
    super.onInit();
    fetchTugasSops();
    fetchSopAndUserList();
  }

  Future<void> fetchSopAndUserList() async {
    try {
      final sops = await _apiProvider.getSops(perPage: 100);
      sopList.assignAll(sops);
      final users = await _apiProvider.getUsers();
      userList.assignAll(users);
    } catch (e) {
      debugPrint("Gagal load dropdown data: $e");
    }
  }

  Future<void> fetchTugasSops() async {
    try {
      isLoading(true);
      final list = await _apiProvider.getTugasSops(
        search: searchController.text,
        perPage: perPage.value,
      );
      tugasSops.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  void searchTugas(String q) {
    fetchTugasSops();
  }

  Future<void> loadLangkahSop(int sopId) async {
    try {
      final langkahs = await _apiProvider.getLangkahSops(sopId: sopId, perPage: 100);
      langkahSopList.assignAll(langkahs);
    } catch (e) {
      debugPrint("Gagal load langkah: $e");
    }
  }

  void onChangeSop(int? sopId) {
    selectedSopId.value = sopId;
    selectedLangkahId.value = null;
    langkahSopList.clear();
    if (sopId != null) {
      loadLangkahSop(sopId);
    }
  }

  void setupForm({bool massal = false}) {
    isMassal.value = massal;
    selectedSopId.value = null;
    selectedUserId.value = null;
    selectedUserIds.clear();
    ditugaskanPada.value = 'semua';
    selectedLangkahId.value = null;
    langkahSopList.clear();
  }

  void toggleUserSelection(int userId) {
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
  }

  Future<void> submitAssignment() async {
    if (selectedSopId.value == null) {
      Get.snackbar('Peringatan', 'SOP harus dipilih',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    List<int> userIds = [];
    if (isMassal.value) {
      if (selectedUserIds.isEmpty) {
         Get.snackbar('Peringatan', 'Pilih minimal 1 karyawan',
             backgroundColor: Colors.red, colorText: Colors.white);
         return;
      }
      userIds = selectedUserIds.toList();
    } else {
      if (selectedUserId.value == null) {
         Get.snackbar('Peringatan', 'Karyawan harus dipilih',
             backgroundColor: Colors.red, colorText: Colors.white);
         return;
      }
      userIds = [selectedUserId.value!];
    }

    if (ditugaskanPada.value == 'tertentu' && selectedLangkahId.value == null) {
      Get.snackbar('Peringatan', 'Langkah harus dipilih',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      Map<String, dynamic> payload = {
        'sop_id': selectedSopId.value,
        'user_ids': userIds,
        'ditugaskan_pada': ditugaskanPada.value,
      };

      if (ditugaskanPada.value == 'tertentu') {
        payload['sop_langkah_ids'] = [selectedLangkahId.value];
      }

      debugPrint("Sending assignment payload: ${json.encode(payload)}");
      final response = await _apiProvider.createTugasSop(payload);
      Get.back(); // close dialog
      Get.snackbar('Sukses', 'Berhasil menugaskan SOP', backgroundColor: Colors.green, colorText: Colors.white);
      fetchTugasSops();
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTugas(int id) async {
    ConfirmDialog.show(
      title: 'Hapus Tugas',
      message: 'Apakah Anda yakin ingin menghapus penugasan ini? Tindakan ini tidak dapat dibatalkan.',
      icon: Icons.delete_forever,
      onConfirm: () async {
        try {
          await _apiProvider.deleteTugasSop(id);
          Get.snackbar(
            'Sukses', 
            'Penugasan berhasil dihapus',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          fetchTugasSops();
        } catch (e) {
           Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
           debugPrint(e.toString());
        }
      },
    );
  }
}
