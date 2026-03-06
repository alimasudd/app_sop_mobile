import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/data/models/user_model.dart';
import 'package:test_maret/app/data/providers/api_provider.dart';

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
  var selectedLevelId = 2.obs; // Default level
  var selectedStatusAktif = 1.obs; // Default status

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    isLoading.value = true;
    try {
      final data = await _apiProvider.getUsers();
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
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(users.where((user) {
        return (user.nama?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (user.email?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList());
    }
  }

  void setupForm([UserModel? user]) {
    if (user != null) {
      namaController.text = user.nama ?? '';
      emailController.text = user.email ?? '';
      hpController.text = user.hp ?? '';
      passwordController.text = ''; // Leave blank on edit
      selectedLevelId.value = user.levelId ?? 2;
      selectedStatusAktif.value = user.statusAktif ?? 1;
    } else {
      namaController.clear();
      emailController.clear();
      hpController.clear();
      passwordController.clear();
      selectedLevelId.value = 2;
      selectedStatusAktif.value = 1;
    }
  }

  void saveUser([int? id]) async {
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Nama dan Email wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Validation Error: Name or Email is empty');
      return;
    }

    isLoading.value = true;
    try {
      final user = UserModel(
        nama: namaController.text,
        email: emailController.text,
        hp: hpController.text,
        levelId: selectedLevelId.value,
        statusAktif: selectedStatusAktif.value,
      );

      if (id == null) {
        // Create
        await _apiProvider.createUser(user);
        Get.snackbar('Sukses', 'User berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
        debugPrint('Create User Success');
      } else {
        // Update
        await _apiProvider.updateUser(id, user);
        Get.snackbar('Sukses', 'User berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
        debugPrint('Update User Success for ID: $id');
      }
      
      // Refresh list
      fetchUsers();
      
      // Close form
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(); 
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint('Save User Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(int id) async {
    Get.defaultDialog(
      title: 'Delete User',
      middleText: 'Are you sure you want to delete this user?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        try {
          await _apiProvider.deleteUser(id);
          Get.snackbar('Sukses', 'User berhasil dihapus',
              backgroundColor: Colors.green, colorText: Colors.white);
          debugPrint('Delete User Success for ID: $id');
          fetchUsers();
        } catch (e) {
          Get.snackbar('Error', 'Gagal menghapus user: $e',
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint('Delete User Error: $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
