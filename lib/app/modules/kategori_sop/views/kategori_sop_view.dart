import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/kategori_sop_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/modules/kategori_sop/controllers/kategori_sop_controller.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';
import 'package:app_sop/app/routes/app_pages.dart';

class KategoriSopView extends GetView<KategoriSopController> {
  const KategoriSopView({Key? key}) : super(key: key);

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
                      if (controller.isLoading.value && controller.kategoriSops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }
                      if (controller.kategoriSops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Data Kategori SOP tidak ditemukan')));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.kategoriSops.length,
                        itemBuilder: (context, index) {
                          final item = controller.kategoriSops[index];
                          return _buildKategoriCard(item, index + 1);
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
            'Kategori SOP',
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
                label: const Text('TAMBAH KATEGORI SOP', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        Get.find<HomeController>().changeIndex(13);
                        if (Get.currentRoute == Routes.KATEGORI_SOP) {
                           Get.offNamed(Routes.HOME);
                        }
                      } else {
                        Get.offNamed(Routes.SOP);
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Gagal menuju Kelola SOP: $e');
                    }
                },
                icon: const Icon(Icons.description, size: 18),
                label: const Text('Kelola SOP', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        controller.fetchKategoriSops(query: controller.searchController.text);
                      }
                    },
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchKategori,
                  decoration: InputDecoration(
                    hintText: 'Cari Kategori...',
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

  Widget _buildKategoriCard(KategoriSopModel item, int no) {
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
                  icon: Icons.list_alt,
                  color: Colors.cyan,
                  onTap: () => _showDetailDialog(item),
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
                  onTap: () => controller.deleteKategori(item.id!),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NAMA KATEGORI', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        item.nama ?? '-',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text('TOTAL SOP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFF1B4EAA), shape: BoxShape.circle),
                        child: Text(
                          '${item.sopsCount ?? 0}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text('STATUS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (item.status == 'aktif') ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.status?.toUpperCase() ?? 'NONE',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('DESKRIPSI', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              item.deskripsi ?? '-',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6C757D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  void _showFormDialog([KategoriSopModel? item]) {
    controller.setupForm(item);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
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
                          item == null ? 'Tambah Kategori SOP' : 'Edit Kategori SOP',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                _label('Kode Kategori *'),
                const SizedBox(height: 8),
                _textField(controller.kodeController, 'Contoh: KAT-001'),
                const SizedBox(height: 16),
                _label('Nama Kategori *'),
                const SizedBox(height: 8),
                _textField(controller.namaController, 'Contoh: Operasional'),
                const SizedBox(height: 16),
                _label('Deskripsi'),
                const SizedBox(height: 8),
                _textField(controller.deskripsiController, 'Deskripsi kategori SOP', maxLines: 3),
                const SizedBox(height: 16),
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
                      items: ['aktif', 'nonaktif'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!));
                      }).toList(),
                      onChanged: (val) => controller.selectedStatus.value = val!,
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(closeOverlays: true), child: const Text('Batal')),
                    const SizedBox(width: 12),
                Obx(() => ElevatedButton.icon(
                  onPressed: controller.isSaving.value ? null : () => controller.saveKategori(item?.id),
                  icon: controller.isSaving.value 
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save, size: 18),
                  label: Text(controller.isSaving.value ? 'Loading...' : (item == null ? 'SIMPAN' : 'Update')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item == null ? const Color(0xFF1B4EAA) : Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )),
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

  void _showDetailDialog(KategoriSopModel item) {
    controller.fetchSopsByCategory(item.id!);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    'Daftar SOP - ${controller.selectedKategoriName.value}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Flexible(
                child: Obx(() {
                  if (controller.isLoadingDetail.value) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (controller.detailSops.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Belum ada SOP di kategori ini.'),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFB)),
                      columns: const [
                        DataColumn(label: Text('NO')),
                        DataColumn(label: Text('KODE')),
                        DataColumn(label: Text('NAMA SOP')),
                        DataColumn(label: Text('VERSI')),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: controller.detailSops.asMap().entries.map((entry) {
                        int idx = entry.key;
                        SopModel sop = entry.value;
                        return DataRow(cells: [
                          DataCell(Text('${idx + 1}')),
                          DataCell(Text(sop.kode ?? '-', style: const TextStyle(color: Colors.pink, fontSize: 11))),
                          DataCell(Text(sop.nama ?? '-')),
                          DataCell(Text(sop.versi ?? '1.0')),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                            child: const Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 10)),
                          )),
                        ]);
                      }).toList(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(closeOverlays: true), child: const Text('Tutup')),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                        Get.back(closeOverlays: true); // Close dialog first
                        try {
                          if (Get.isRegistered<HomeController>()) {
                            Get.find<HomeController>().changeIndex(13);
                            if (Get.currentRoute == Routes.KATEGORI_SOP) {
                               Get.offNamed(Routes.HOME);
                            }
                          } else {
                            Get.offNamed(Routes.SOP);
                          }
                        } catch (e) {
                          Get.snackbar('Error', 'Gagal menuju Kelola SOP: $e');
                        }
                    },
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Kelola SOP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
