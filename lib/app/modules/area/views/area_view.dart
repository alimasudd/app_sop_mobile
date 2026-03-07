import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/modules/area/controllers/area_controller.dart';

class AreaView extends GetView<AreaController> {
  const AreaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _buildHeader(),
          
          _buildToolbar(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.areas.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.filteredAreas.isEmpty) {
                return const Center(child: Text('Data area tidak ditemukan'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredAreas.length,
                itemBuilder: (context, index) {
                  final area = controller.filteredAreas[index];
                  return _buildAreaCard(area, index + 1);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Master Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
              ),
              SizedBox(width: 8),
              Text(
                'Area',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
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
                onPressed: () => _showAreaForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('TAMBAH AREA', style: TextStyle(fontWeight: FontWeight.bold)),
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
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchArea,
                  decoration: InputDecoration(
                    hintText: 'Cari Area...',
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

  Widget _buildAreaCard(AreaModel area, int no) {
    return Card(
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
                  onTap: () => _showAreaForm(area),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: 'Hapus',
                  color: Colors.red,
                  onTap: () => controller.deleteArea(area.id!),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('NAMA AREA', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              area.namaArea ?? '-',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
            ),
            const SizedBox(height: 12),
            const Text('DESKRIPSI', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              (area.deskripsi == null || area.deskripsi!.isEmpty) ? '-' : area.deskripsi!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
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

  void _showAreaForm([AreaModel? area]) {
    controller.setupForm(area);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    area == null ? 'Tambah Area' : 'Edit Area',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              const Text('Nama Area', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.namaAreaController,
                decoration: InputDecoration(
                  hintText: 'Contoh: North Pit Area',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Deskripsi optional',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => controller.saveArea(area?.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4EAA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(area == null ? 'SIMPAN' : 'UPDATE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
