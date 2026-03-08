import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';

class LangkahSopController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Data lists
  var langkahList = <SopLangkahModel>[].obs;
  var sopList = <SopModel>[].obs;
  var ruangList = <RuangModel>[].obs;
  var userList = <UserModel>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var perPage = 10.obs;

  // Filter selection
  var filterSopId = Rxn<int>();
  var filterWajib = Rxn<int>();
  var isFilterExpanded = false.obs;

  var filterSearchController = TextEditingController();

  // Form Controls
  var selectedSopId = Rxn<int>();
  var selectedRuangId = Rxn<int>();
  var selectedUserId = Rxn<int>();
  var selectedWajib = 1.obs; // 1 = ya, 0 = tidak
  var isWaReminder = false.obs;

  var urutanController = TextEditingController();
  var deskripsiController = TextEditingController();
  var poinController = TextEditingController();
  var deadlineController = TextEditingController();
  var toleransiSebelumController = TextEditingController();
  var toleransiSesudahController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Use dummy data initially, then fetch from API
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      final sops = await _apiProvider.getSops();
      sopList.value = sops;

      final ruangs = await _apiProvider.getRuangs();
      ruangList.value = ruangs;

      final users = await _apiProvider.getUsers();
      userList.value = users;

      await fetchLangkah();
    } catch (e) {
      print('Fetch Initial Data Error: $e');
      Get.snackbar('Error', 'Gagal memuat data master',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLangkah() async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getLangkahSops(
        search: filterSearchController.text,
        sopId: filterSopId.value,
        perPage: perPage.value,
      );
      // Optional: manual filter by wajib if api doesn't support
      var filtered = data;
      if (filterWajib.value != null) {
        filtered = filtered.where((e) => e.wajib == filterWajib.value).toList();
      }
      langkahList.value = filtered;
    } catch (e) {
      print('Fetch Langkah Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilter() {
    filterSopId.value = null;
    filterWajib.value = null;
    filterSearchController.clear();
    fetchLangkah();
  }

  void resetForm() {
    selectedSopId.value = null;
    selectedRuangId.value = null;
    selectedUserId.value = null;
    selectedWajib.value = 1;
    isWaReminder.value = false;
    urutanController.text = '1';
    deskripsiController.clear();
    poinController.text = '10';
    deadlineController.clear();
    toleransiSebelumController.clear();
    toleransiSesudahController.clear();
  }

  void onSopSelectedForForm(int? sopId) {
    selectedSopId.value = sopId;
    if (sopId != null) {
      // Auto increment urutan based on selected SOP
      final stepsInSop = langkahList.where((l) => l.sopId == sopId).toList();
      int maxUrutan = 0;
      for (var step in stepsInSop) {
        if (step.urutan != null && step.urutan! > maxUrutan) {
          maxUrutan = step.urutan!;
        }
      }
      urutanController.text = (maxUrutan + 1).toString();
    }
  }

  void openFormDialog({SopLangkahModel? langkah}) {
    if (langkah != null) {
      selectedSopId.value = langkah.sopId;
      selectedRuangId.value = langkah.ruangId;
      selectedUserId.value = langkah.userId;
      selectedWajib.value = langkah.wajib ?? 1;
      isWaReminder.value = langkah.waReminder == 1;
      urutanController.text = langkah.urutan?.toString() ?? '1';
      deskripsiController.text = langkah.deskripsiLangkah ?? '';
      poinController.text = langkah.poin?.toString() ?? '10';
      deadlineController.text = langkah.deadlineWaktu ?? '';
      toleransiSebelumController.text = langkah.toleransiWaktuSebelum ?? '';
      toleransiSesudahController.text = langkah.toleransiWaktuSesudah ?? '';
    } else {
      resetForm();
    }
  }

  Future<void> submitForm({SopLangkahModel? langkah}) async {
    if (selectedSopId.value == null || deskripsiController.text.isEmpty || urutanController.text.isEmpty) {
      Get.snackbar('Peringatan', 'SOP, Urutan, dan Deskripsi Langkah harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    try {
      final input = SopLangkahModel(
        sopId: selectedSopId.value,
        ruangId: selectedRuangId.value,
        userId: selectedUserId.value,
        urutan: int.tryParse(urutanController.text) ?? 1,
        deskripsiLangkah: deskripsiController.text,
        wajib: selectedWajib.value,
        poin: int.tryParse(poinController.text) ?? 0,
        deadlineWaktu: deadlineController.text,
        toleransiWaktuSebelum: toleransiSebelumController.text,
        toleransiWaktuSesudah: toleransiSesudahController.text,
        waReminder: isWaReminder.value ? 1 : 0,
      );

      if (langkah != null && langkah.id != null) {
        await _apiProvider.updateLangkahSop(langkah.id!, input);
        Get.back(closeOverlays: true);
        Get.snackbar('Sukses', 'Langkah SOP berhasil diubah',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.createLangkahSop(input);
        Get.back(closeOverlays: true);
        Get.snackbar('Sukses', 'Langkah SOP berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchLangkah();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteLangkah(int id) async {
    ConfirmDialog.show(
      title: 'Hapus Langkah',
      message: 'Apakah Anda yakin ingin menghapus langkah SOP ini?',
      icon: Icons.delete_outline,
      onConfirm: () async {
        try {
          await _apiProvider.deleteLangkahSop(id);
          Get.snackbar('Sukses', 'Langkah SOP berhasil dihapus',
              backgroundColor: Colors.green, colorText: Colors.white);
          fetchLangkah();
        } catch (e) {
          Get.snackbar('Error', 'Gagal menghapus langkah SOP',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }
}
