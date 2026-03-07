import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class UsersController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isLoading = false.obs;
  
  // Search
  final searchController = TextEditingController();

  // Form Controllers
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final passwordController = TextEditingController();
  final jabatanController = TextEditingController();
  
  var selectedLevelId = Rxn<int>(); // Nullable for "-- Pilih Level --"
  var selectedStatusAktif = 1.obs; // Default status (Aktif)

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers({String? query}) async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getUsers(search: query);
      users.assignAll(data);
      filteredUsers.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data user: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Fetch Users Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchUser(String query) {
    // Calling API for server-side search (matching PHP index method)
    fetchUsers(query: query);
  }

  void setupForm([UserModel? user]) {
    if (user != null) {
      namaController.text = user.nama ?? '';
      emailController.text = user.email ?? '';
      hpController.text = user.hp ?? '';
      jabatanController.text = user.jabatan ?? '';
      passwordController.text = ''; // Leave blank on edit
      selectedLevelId.value = user.levelId;
      selectedStatusAktif.value = user.statusAktif ?? 1;
    } else {
      namaController.clear();
      emailController.clear();
      hpController.clear();
      jabatanController.clear();
      passwordController.clear();
      selectedLevelId.value = null;
      selectedStatusAktif.value = 1;
    }
  }

  void saveUser([int? id]) async {
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Nama dan Email wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (id == null && passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password wajib diisi untuk user baru',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    try {
      final user = UserModel(
        nama: namaController.text,
        email: emailController.text,
        hp: hpController.text,
        jabatan: jabatanController.text,
        password: passwordController.text.isNotEmpty ? passwordController.text : null,
        levelId: selectedLevelId.value ?? 5, // Default to 5 (Staff) as per PHP store method
        statusAktif: selectedStatusAktif.value,
      );

      if (id == null) {
        await _apiProvider.createUser(user);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        Get.back(); 
        Get.snackbar('Sukses', 'User berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _apiProvider.updateUser(id, user);
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        Get.back(); 
        Get.snackbar('Sukses', 'User berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      
      fetchUsers();
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      Get.snackbar('Gagal', errorMessage,
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save User Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(int id) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Hapus User', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus user ini? Tindakan ini tidak dapat dibatalkan.'),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              try {
                await _apiProvider.deleteUser(id);
                Get.snackbar('Sukses', 'User berhasil dihapus',
                    backgroundColor: Colors.green, colorText: Colors.white);
                fetchUsers();
              } catch (e) {
                Get.snackbar('Error', 'Gagal menghapus user: $e',
                    backgroundColor: Colors.red, colorText: Colors.white);
                debugPrint('Delete User Error: $e');
              } finally {
                isLoading.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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
