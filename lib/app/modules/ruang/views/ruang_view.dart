import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/modules/ruang/controllers/ruang_controller.dart';

class RuangView extends GetView<RuangController> {
  const RuangView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Content (Sticky)
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToolbar(),
                    Obx(() {
                      if (controller.isLoading.value && controller.rooms.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }
                      if (controller.rooms.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Data ruang tidak ditemukan')));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.rooms.length,
                        itemBuilder: (context, index) {
                          final room = controller.rooms[index];
                          return _buildRoomCard(room, index + 1);
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: const [
          Text(
            'Master Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF242B42)),
          ),
          SizedBox(width: 8),
          Text(
            'Ruang',
            style: TextStyle(fontSize: 14, color: Color(0xFF7E8494)),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showRoomForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('TAMBAH RUANG', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4EAA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFDDE2E5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<int>(
                    value: controller.perPage.value,
                    items: const [
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 25, child: Text('25')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        controller.perPage.value = val;
                        controller.fetchRooms(query: controller.searchController.text);
                      }
                    },
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchRoom,
                  decoration: InputDecoration(
                    hintText: 'Cari Ruang...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(RuangModel room, int no) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'No: $no',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B4EAA)),
                  ),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.edit_note,
                  label: 'Edit',
                  color: Colors.orange,
                  onTap: () => _showRoomForm(room),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: 'Hapus',
                  color: Colors.red,
                  onTap: () => controller.deleteRoom(room.id!),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('NAMA RUANG', room.nama ?? '-', true),
            const SizedBox(height: 12),
            _buildInfoRow('AREA', room.area?.nama ?? '-', false),
            const SizedBox(height: 12),
            _buildInfoRow('DESKRIPSI', room.des ?? '-', false),
            const SizedBox(height: 12),
            _buildInfoRow('TANGGAL DIBUAT', room.createdAt ?? '-', false),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isBold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: TextStyle(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF343A40),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showRoomForm([RuangModel? room]) {
    controller.setupForm(room);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room == null ? 'Tambah Ruang' : 'Edit Ruang',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
                    ),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Get.back()),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Area', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDDE2E5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: controller.selectedAreaId.value,
                      hint: const Text('-- Pilih Area --'),
                      items: controller.areas.map((area) {
                        return DropdownMenuItem<int>(
                          value: area.id,
                          child: Text(area.nama ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) => controller.selectedAreaId.value = val,
                    ),
                  ),
                )),
                const SizedBox(height: 16),
                const Text('Nama Ruang', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.namaRuangController,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Ruang Kursus Komputer',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi optional',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => controller.saveRoom(room?.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4EAA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(room == null ? 'SIMPAN' : 'UPDATE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
