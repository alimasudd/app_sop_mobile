import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/modules/sop/controllers/sop_controller.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';
import 'package:app_sop/app/routes/app_pages.dart';

class SopView extends GetView<SopController> {
  const SopView({Key? key}) : super(key: key);

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
                      if (controller.isLoading.value && controller.sops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }
                      if (controller.sops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Data SOP tidak ditemukan')));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.sops.length,
                        itemBuilder: (context, index) {
                          final item = controller.sops[index];
                          return _buildSopCard(item, index + 1);
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
            'SOP (Standard Operating Procedure)',
            style: TextStyle(fontSize: 14, color: Color(0xFF7E8494)),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showFormDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('TAMBAH SOP', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4EAA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                    try {
                      if (Get.isRegistered<HomeController>()) {
                        Get.find<HomeController>().changeIndex(12);
                        // Jika saat ini SopView dibuka sebagai dialog atau route di atas HomeView
                        if (Get.currentRoute == Routes.SOP) {
                           Get.offNamed(Routes.HOME);
                        }
                      } else {
                        Get.offNamed(Routes.KATEGORI_SOP);
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Gagal menuju Kelola Kategori: $e');
                    }
                },
                icon: const Icon(Icons.folder, size: 18),
                label: const Text('Kelola Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
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
                        controller.fetchSops();
                      }
                    },
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchSop,
                  decoration: InputDecoration(
                    hintText: 'Cari SOP...',
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

  Widget _buildSopCard(SopModel item, int no) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'No: $no',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B4EAA)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.kode ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 13),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: const Color(0xFF2575FC),
                  onTap: () {
                     // Show Details
                  },
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.edit_note,
                  color: Colors.orange,
                  onTap: () => _showFormDialog(item),
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  onTap: () => controller.deleteSop(item.id!),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NAMA SOP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        item.nama ?? '-',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        item.deskripsi ?? '-',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                         maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Table like info
                Expanded(
                  flex: 4,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    alignment: WrapAlignment.end,
                    children: [
                      _infoColumn('KATEGORI', item.kategori?['nama'] ?? '-', Colors.cyan),
                      _infoColumn('TIPE', item.statusSop ?? 'mutlak', const Color(0xFF2575FC)),
                      _infoColumn('VERSI', item.versi ?? '1.0', Colors.grey),
                      _infoBadge('LANGKAH', '${item.langkahCount ?? 0}', Colors.purple),
                      _infoBadge('POIN', '${item.totalPoin ?? 0}', Colors.green),
                      _infoColumn('STATUS', item.status?.capitalizeFirst! ?? 'Aktif', Colors.green),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _infoBadge(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  void _showFormDialog([SopModel? item]) {
    controller.setupForm(item);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Get.width * 0.8,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         Icon(item == null ? Icons.add_circle : Icons.edit, color: const Color(0xFF343A40)),
                         const SizedBox(width: 8),
                         Text(
                          item == null ? 'Tambah SOP' : 'Edit SOP',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                
                _label('Kategori SOP *'),
                const SizedBox(height: 8),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDDE2E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      hint: const Text('-- Pilih Kategori --'),
                      value: controller.selectedKategoriId.value,
                      items: controller.kategoriList.map((e) {
                        return DropdownMenuItem<int>(value: e.id, child: Text(e.nama ?? '-'));
                      }).toList(),
                      onChanged: (val) => controller.selectedKategoriId.value = val,
                    ),
                  ),
                )),
                
                const SizedBox(height: 16),
                _label('Kode SOP *'),
                const SizedBox(height: 8),
                _textField(controller.kodeController, 'Contoh: SOP-OPR-001'),
                
                const SizedBox(height: 16),
                _label('Nama SOP *'),
                const SizedBox(height: 8),
                _textField(controller.namaController, 'Contoh: SOP Pengoperasian Dump Truck'),
                
                const SizedBox(height: 16),
                _label('Deskripsi'),
                const SizedBox(height: 8),
                _textField(controller.deskripsiController, 'Deskripsi lengkap SOP', maxLines: 3),
                
                const SizedBox(height: 16),
                _label('Versi'),
                const SizedBox(height: 8),
                _textField(controller.versiController, '1.0'),
                
                const SizedBox(height: 16),
                _label('Tanggal Berlaku'),
                const SizedBox(height: 8),
                _textField(controller.tanggalBerlakuController, 'yyyy-mm-dd'),
                
                const SizedBox(height: 16),
                _label('Tanggal Kadaluarsa'),
                const SizedBox(height: 8),
                _textField(controller.tanggalKadaluarsaController, 'yyyy-mm-dd'),
                
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Status'),
                          const SizedBox(height: 8),
                          Obx(() => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDDE2E5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: controller.selectedStatus.value,
                                items: ['aktif', 'nonaktif', 'draft', 'expired'].map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!));
                                }).toList(),
                                onChanged: (val) => controller.selectedStatus.value = val!,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           _label('Tipe SOP *'),
                           const SizedBox(height: 8),
                           Obx(() => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDDE2E5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: controller.selectedStatusSop.value,
                                items: ['mutlak', 'custom'].map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!));
                                }).toList(),
                                onChanged: (val) => controller.selectedStatusSop.value = val!,
                              ),
                            ),
                          )),
                        ],
                      )
                    )
                  ],
                ),
                
                const SizedBox(height: 16),
                _label('Pengawas SOP'),
                const SizedBox(height: 8),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFDDE2E5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('-- Tanpa Pengawas --'),
                        value: null,
                        items: const [],
                        onChanged: (val) {},
                      ),
                    ),
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(closeOverlays: true), child: const Text('Batal')),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => controller.saveSop(item?.id),
                      icon: const Icon(Icons.save, size: 18),
                      label: Text(item == null ? 'SIMPAN' : 'Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item == null ? const Color(0xFF1B4EAA) : Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13));
  }

  Widget _textField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
        ),
      ),
    );
  }
}
