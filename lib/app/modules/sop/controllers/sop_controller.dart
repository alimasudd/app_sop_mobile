import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/kategori_sop_model.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';

class SopController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  var sops = <SopModel>[].obs;
  var kategoriList = <KategoriSopModel>[].obs;
  
  var isLoading = true.obs;
  var isSaving = false.obs;
  var perPage = 10.obs;

  final searchController = TextEditingController();

  // Form Controllers
  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final versiController = TextEditingController();
  final tanggalBerlakuController = TextEditingController();
  final tanggalKadaluarsaController = TextEditingController();
  
  var selectedKategoriId = RxnInt();
  var selectedStatus = 'aktif'.obs;
  var selectedPeriode = 'Harian'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategori();
    fetchSops();
  }

  void fetchKategori() async {
    try {
      final data = await _apiProvider.getKategoriSops(perPage: 100);
      kategoriList.assignAll(data);
    } catch (e) {
      debugPrint('Fetch Kategori Error: $e');
    }
  }

  void fetchSops() async {
    try {
      isLoading(true);
      final data = await _apiProvider.getSops(search: searchController.text, perPage: perPage.value);
      sops.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch SOP Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void searchSop(String value) {
    fetchSops();
  }

  void setupForm([SopModel? item]) {
    if (item != null) {
      kodeController.text = item.kode ?? '';
      namaController.text = item.nama ?? '';
      deskripsiController.text = item.deskripsi ?? '';
      versiController.text = item.versi ?? '1.0';
      tanggalBerlakuController.text = item.tanggalBerlaku ?? '';
      tanggalKadaluarsaController.text = item.tanggalKadaluarsa ?? '';
      selectedKategoriId.value = item.katsopId;
      selectedStatus.value = item.status == 'nonaktif' ? 'nonaktif' : 'aktif';
      selectedPeriode.value = item.periode ?? 'Harian';
    } else {
      kodeController.clear();
      namaController.clear();
      deskripsiController.clear();
      versiController.text = '1.0';
      tanggalBerlakuController.clear();
      tanggalKadaluarsaController.clear();
      selectedKategoriId.value = null;
      selectedStatus.value = 'aktif';
      selectedPeriode.value = 'Harian';
    }
  }

  Future<void> saveSop(int? id) async {
    if (selectedKategoriId.value == null || kodeController.text.isEmpty || namaController.text.isEmpty) {
      Get.snackbar('Error', 'Kategori, Kode dan Nama SOP wajib diisi', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSaving(true);
      
      String? tglBerlaku = tanggalBerlakuController.text.isEmpty ? null : tanggalBerlakuController.text;
      String? tglKadaluarsa = tanggalKadaluarsaController.text.isEmpty ? null : tanggalKadaluarsaController.text;

      final sop = SopModel(
        katsopId: selectedKategoriId.value,
        kode: kodeController.text,
        nama: namaController.text,
        deskripsi: deskripsiController.text,
        versi: versiController.text,
        tanggalBerlaku: tglBerlaku,
        tanggalKadaluarsa: tglKadaluarsa,
        status: selectedStatus.value,
        periode: selectedPeriode.value,
      );

      if (id == null) {
        await _apiProvider.createSop(sop);
      } else {
        await _apiProvider.updateSop(id, sop);
      }

      // Close Dialog gracefully
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      fetchSops();
      Get.snackbar('Sukses', 'Data SOP berhasil disimpan', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save SOP Error: $e');
    } finally {
      isSaving(false);
    }
  }

  Future<void> deleteSop(int id) async {
    ConfirmDialog.show(
      title: 'Hapus SOP',
      message: 'Apakah Anda yakin ingin menghapus SOP ini? Semua langkah di dalamnya akan ikut terhapus.',
      icon: Icons.warning_amber_rounded,
      onConfirm: () async {
        try {
          await _apiProvider.deleteSop(id);
          fetchSops();
          Get.snackbar('Sukses', 'Data berhasil dihapus', backgroundColor: Colors.green, colorText: Colors.white);
        } catch (e) {
          Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }
}
