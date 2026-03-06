import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maret/app/data/models/user_model.dart';
import 'package:test_maret/app/modules/users/controllers/users_controller.dart';
import 'package:test_maret/app/modules/users/views/user_form_view.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmbedded = Get.routing.current == '/home' || Get.routing.current == '/';
    
    Widget content = Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.filteredUsers.isEmpty) {
              return const Center(child: Text("Data user tidak ditemukan"));
            }
            return RefreshIndicator(
              onRefresh: () async => controller.fetchUsers(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  return _buildUserCard(user);
                },
              ),
            );
          }),
        ),
      ],
    );

    if (isEmbedded) {
      return Scaffold(
        body: content,
        floatingActionButton: _buildFAB(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Manajemen User'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
      ),
      body: content,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        controller.setupForm();
        Get.to(() => const UserFormView());
      },
      backgroundColor: const Color(0xFF6A11CB),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.searchUser,
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan nama atau email...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2575FC).withOpacity(0.1),
          child: Text(
            user.nama?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(color: Color(0xFF2575FC), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.nama ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email ?? '-'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(user.hp ?? '-', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                controller.setupForm(user);
                Get.to(() => UserFormView(user: user));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.deleteUser(user.id!),
            ),
          ],
        ),
      ),
    );
  }
}
