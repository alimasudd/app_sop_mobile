import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:app_sop/app/data/models/sop_pelaksanaan_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';
import 'package:intl/intl.dart';

class PelaksanaanSopController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Data lists
  var pelaksanaanList = <SopPelaksanaanModel>[].obs;
  var sopList = <SopModel>[].obs;
  var userList = <UserModel>[].obs;
  var areaList = <AreaModel>[].obs;
  var ruangList = <RuangModel>[].obs;
  var langkahList = <SopLangkahModel>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var perPage = 10.obs;

  // Search & Filter
  var searchController = TextEditingController();

  // Form Controls
  var selectedSopId = Rxn<int>();
  var selectedLangkahId = Rxn<int>();
  var selectedUserId = Rxn<int>();
  var selectedAreaId = Rxn<int>();
  var selectedRuangId = Rxn<int>();
  var selectedStatusSop = Rxn<int>(0); // Default Harian
  
  var poinController = TextEditingController(text: '0');
  var urlBuktiController = TextEditingController();
  var desController = TextEditingController();
  
  var deadlineWaktuController = TextEditingController();
  var toleransiSebelumController = TextEditingController();
  var toleransiSesudahController = TextEditingController();
  var waktuMulaiController = TextEditingController();
  var waktuSelesaiController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      final sops = await _apiProvider.getSops();
      sopList.assignAll(sops);

      final users = await _apiProvider.getUsers();
      userList.assignAll(users);

      final areas = await _apiProvider.getAreas();
      areaList.assignAll(areas);

      final ruangs = await _apiProvider.getRuangs();
      ruangList.assignAll(ruangs);

      await fetchPelaksanaans();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data awal: $e', 
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Gagal memuat data awal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPelaksanaans() async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getPelaksanaanSops(
        search: searchController.text,
        perPage: perPage.value,
      );
      pelaksanaanList.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pelaksanaan SOP: $e', 
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Gagal memuat pelaksanaan SOP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLangkahBySop(int sopId) async {
    try {
      final data = await _apiProvider.getLangkahSops(sopId: sopId);
      langkahList.assignAll(data);
    } catch (e) {
      print('Error fetch langkah: $e');
    }
  }

  void onSopChanged(int? sopId) {
    selectedSopId.value = sopId;
    selectedLangkahId.value = null;
    langkahList.clear();
    if (sopId != null) {
      fetchLangkahBySop(sopId);
      
      // Auto-set property from SOP model if found
      final selectedSop = sopList.firstWhereOrNull((e) => e.id == sopId);
      if (selectedSop != null) {
        // Map status string to integer index if possible
        // 0=Harian, 1=Mingguan, 2=Bulanan, 3=Tahunan
        // Adjust this mapping based on your SOP periode string
      }
    }
  }

  void resetForm() {
    selectedSopId.value = null;
    selectedLangkahId.value = null;
    selectedUserId.value = null;
    selectedAreaId.value = null;
    selectedRuangId.value = null;
    selectedStatusSop.value = 0;
    
    poinController.text = '0';
    urlBuktiController.clear();
    desController.clear();
    
    deadlineWaktuController.clear();
    toleransiSebelumController.clear();
    toleransiSesudahController.clear();
    waktuMulaiController.clear();
    waktuSelesaiController.clear();
    
    langkahList.clear();
  }

  void openFormDialog({SopPelaksanaanModel? pelaksanaan}) {
    if (pelaksanaan != null) {
      selectedSopId.value = pelaksanaan.sopId;
      selectedLangkahId.value = pelaksanaan.sopLangkahId;
      selectedUserId.value = pelaksanaan.userId;
      selectedAreaId.value = pelaksanaan.areaId;
      selectedRuangId.value = pelaksanaan.ruangId;
      selectedStatusSop.value = pelaksanaan.statusSop ?? 0;
      
      poinController.text = pelaksanaan.poin?.toString() ?? '0';
      urlBuktiController.text = pelaksanaan.url ?? '';
      desController.text = pelaksanaan.des ?? '';
      
      deadlineWaktuController.text = _formatTimestamp(pelaksanaan.deadlineWaktu);
      toleransiSebelumController.text = _formatTimestamp(pelaksanaan.toleransiWaktuSebelum);
      toleransiSesudahController.text = _formatTimestamp(pelaksanaan.toleransiWaktuSesudah);
      waktuMulaiController.text = _formatTimestamp(pelaksanaan.waktuMulai);
      waktuSelesaiController.text = _formatTimestamp(pelaksanaan.waktuSelesai);
      
      if (pelaksanaan.sopId != null) {
        fetchLangkahBySop(pelaksanaan.sopId!);
      }
    } else {
      resetForm();
    }
    
    // Safety check: ensure dropdown lists are not empty when editing
    if (sopList.isEmpty || userList.isEmpty) {
      fetchInitialData();
    }
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  int? _parseTimestamp(String text) {
    if (text.isEmpty) return null;
    try {
      final dt = DateFormat('dd/MM/yyyy HH:mm').parse(text);
      return dt.millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }

  Future<void> submitForm({SopPelaksanaanModel? pelaksanaan}) async {
    if (selectedSopId.value == null || selectedUserId.value == null) {
      Get.snackbar('Peringatan', 'SOP dan Pelaksana harus diisi', 
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    try {
      final input = SopPelaksanaanModel(
        sopId: selectedSopId.value,
        sopLangkahId: selectedLangkahId.value,
        userId: selectedUserId.value,
        areaId: selectedAreaId.value,
        ruangId: selectedRuangId.value,
        statusSop: selectedStatusSop.value,
        poin: int.tryParse(poinController.text) ?? 0,
        url: urlBuktiController.text,
        des: desController.text,
        deadlineWaktu: _parseTimestamp(deadlineWaktuController.text),
        toleransiWaktuSebelum: _parseTimestamp(toleransiSebelumController.text),
        toleransiWaktuSesudah: _parseTimestamp(toleransiSesudahController.text),
        waktuMulai: _parseTimestamp(waktuMulaiController.text),
        waktuSelesai: _parseTimestamp(waktuSelesaiController.text),
      );

      if (pelaksanaan != null && pelaksanaan.id != null) {
        await _apiProvider.updatePelaksanaanSop(pelaksanaan.id!, input);
        Get.back(closeOverlays: true);
        Get.snackbar('Sukses', 'Pelaksanaan SOP berhasil diubah', 
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.createPelaksanaanSop(input);
        Get.back(closeOverlays: true);
        Get.snackbar('Sukses', 'Pelaksanaan SOP berhasil ditambahkan', 
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchPelaksanaans();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e', 
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Gagal menyimpan data: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deletePelaksanaan(int id) async {
    ConfirmDialog.show(
      title: 'Hapus Pelaksanaan',
      message: 'Apakah Anda yakin ingin menghapus catatan pelaksanaan ini?',
      onConfirm: () async {
        try {
          await _apiProvider.deletePelaksanaanSop(id);
          Get.snackbar('Sukses', 'Data berhasil dihapus', 
              backgroundColor: Colors.green, colorText: Colors.white);
          fetchPelaksanaans();
        } catch (e) {
          Get.snackbar('Error', 'Gagal menghapus data: $e', 
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint('Gagal menghapus data: $e');
        }
      },
    );
  }
}
