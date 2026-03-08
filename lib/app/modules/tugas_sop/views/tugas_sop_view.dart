import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/tugas_sop_model.dart';
import 'package:app_sop/app/modules/tugas_sop/controllers/tugas_sop_controller.dart';
import 'package:intl/intl.dart';

class TugasSopView extends GetView<TugasSopController> {
  const TugasSopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildInfoBox(),
          _buildToolbar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.tugasSops.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.tugasSops.isEmpty) {
                return const Center(child: Text('Data Penugasan SOP tidak ditemukan'));
              }
              return _buildDataTable();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: const Row(
        children: [
          Text(
            'Master Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
          ),
          SizedBox(width: 8),
          Text(
            'Tugas SOP',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00C7E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Informasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(
                  'Halaman ini digunakan untuk menugaskan karyawan pada SOP tertentu. Anda bisa menugaskan karyawan ke seluruh langkah dalam SOP, atau langkah tertentu saja.',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.setupForm(massal: false);
                    _showFormDialog();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('TAMBAH PENUGASAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4EAA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.setupForm(massal: true);
                    _showFormDialog();
                  },
                  icon: const Icon(Icons.people, size: 18),
                  label: const Text('Penugasan Massal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C897),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
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
                        controller.fetchTugasSops();
                      }
                    },
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchTugas,
                  decoration: InputDecoration(
                    hintText: 'Cari Tugas SOP...',
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
          dataRowMaxHeight: 80,
          dataRowMinHeight: 70,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('NAMA SOP', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('LANGKAH', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('KATEGORI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('KARYAWAN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('NO WA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('TANGGAL TUGAS', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
            DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
          ],
          rows: controller.tugasSops.asMap().entries.map((entry) {
            int idx = entry.key + 1;
            TugasSopModel item = entry.value;

            // Parsing Data
            String kode = item.sop?['kode'] ?? '-';
            String namaSop = item.sop?['nama'] ?? '-';
            String kategoriName = item.sop?['kategori']?['nama'] ?? '-';

            // Langkah Badge Config
            bool isSemua = item.langkah == null;
            String langkahText = isSemua ? 'Semua Langkah' : 'Langkah #${item.langkah?['urutan_langkah'] ?? '?'}';
            Color langkahColor = isSemua ? const Color(0xFF10B981) : const Color(0xFF3B82F6);
            String langkahSubtext = isSemua ? '' : (item.langkah?['deskripsi_langkah'] ?? '');

            // Karyawan
            String userNama = item.user?['nama'] ?? '-';
            String userEmail = item.user?['email'] ?? '-';
            String userHp = item.user?['handphone'] ?? '-';
            
            // Tanggal
            String tanggal = '-';
            if (item.createdAt != null) {
              try {
                DateTime dt = DateTime.parse(item.createdAt!);
                tanggal = DateFormat('dd/MM/yyyy HH:mm').format(dt);
              } catch (e) {
                tanggal = item.createdAt!;
              }
            }

            return DataRow(cells: [
              DataCell(Text('$idx')),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kode, style: const TextStyle(color: Colors.pink, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(namaSop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF374151))),
                ],
              )),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: langkahColor, borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSemua) const Icon(Icons.list, color: Colors.white, size: 12),
                        if (!isSemua) const Icon(Icons.check_box, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(langkahText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (!isSemua && langkahSubtext.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(langkahSubtext, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1),
                    )
                ],
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF00C7E6), borderRadius: BorderRadius.circular(4)),
                child: Text(kategoriName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )),
              DataCell(Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF3B82F6), size: 16),
                  const SizedBox(width: 4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userNama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF374151))),
                      Text(userEmail, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              )),
              DataCell(Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Color(0xFF10B981), size: 14),
                  const SizedBox(width: 4),
                  Text(userHp, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )),
              DataCell(Text(tanggal, style: const TextStyle(color: Colors.grey, fontSize: 12))),
              DataCell(ElevatedButton.icon(
                onPressed: () => controller.deleteTugas(item.id!),
                icon: const Icon(Icons.delete, size: 14),
                label: const Text('Hapus', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  minimumSize: const Size(0, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showFormDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Get.width * 0.7,
          padding: const EdgeInsets.all(24),
          child: Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         Icon(controller.isMassal.value ? Icons.people : Icons.add_circle, color: const Color(0xFF343A40)),
                         const SizedBox(width: 8),
                         Text(
                          controller.isMassal.value ? 'Penugasan SOP Massal' : 'Tambah Penugasan SOP',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Pilih SOP *'),
                          const SizedBox(height: 8),
                          _buildDropdownSearch<int>(
                            hint: '-- Pilih SOP --',
                            value: controller.selectedSopId.value,
                            items: controller.sopList.map((e) => DropdownMenuItem(value: e.id, child: Text('[${e.kode}] ${e.nama}'))).toList(),
                            onChanged: (val) {
                              controller.onChangeSop(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label(controller.isMassal.value ? 'Pilih Karyawan * (Dapat memilih lebih dari satu)' : 'Pilih Karyawan *'),
                          const SizedBox(height: 8),
                          if (!controller.isMassal.value)
                            _buildDropdownSearch<int>(
                              hint: '-- Pilih Karyawan --',
                              value: controller.selectedUserId.value,
                              items: controller.userList.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.nama} (${e.email})'))).toList(),
                              onChanged: (val) {
                                controller.selectedUserId.value = val;
                              },
                            )
                          else
                            _buildMultiSelectUser(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _label('Ditugaskan Pada *'),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Semua Langkah — Karyawan bertanggung jawab untuk seluruh langkah di SOP ini', style: TextStyle(fontSize: 13, color: Color(0xFF374151))),
                  value: 'semua',
                  groupValue: controller.ditugaskanPada.value,
                  onChanged: (val) => controller.ditugaskanPada.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF2575FC),
                ),
                RadioListTile<String>(
                  title: const Text('Langkah Tertentu — Pilih langkah spesifik yang ditugaskan', style: TextStyle(fontSize: 13, color: Color(0xFF374151))),
                  value: 'tertentu',
                  groupValue: controller.ditugaskanPada.value,
                  onChanged: (val) => controller.ditugaskanPada.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF2575FC),
                ),

                if (controller.ditugaskanPada.value == 'tertentu') ...[
                  const SizedBox(height: 16),
                  _label('Pilih Langkah'),
                  const SizedBox(height: 8),
                  _buildDropdownSearch<int>(
                    hint: 'Pilih Langkah...',
                    value: controller.selectedLangkahId.value,
                    items: controller.langkahSopList.map((e) => DropdownMenuItem(value: e.id, child: Text('Langkah #${e.urutan}: ${e.deskripsiLangkah}'))).toList(),
                    onChanged: (val) {
                      controller.selectedLangkahId.value = val;
                    },
                  ),
                ],

                if (controller.isMassal.value) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF00C7E6), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('Karyawan yang sudah ditugaskan pada SOP/langkah ini akan dilewati secara otomatis.', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  )
                ],

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(), child: const Text('Batal', style: TextStyle(color: Color(0xFF4B5563)))),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => controller.submitAssignment(),
                      icon: const Icon(Icons.save, size: 18),
                      label: Text(controller.isMassal.value ? 'Simpan Penugasan Massal' : 'SIMPAN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isMassal.value ? const Color(0xFF00C897) : const Color(0xFF1B4EAA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildMultiSelectUser() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE2E5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedUserIds.map((userId) {
              final user = controller.userList.firstWhereOrNull((u) => u.id == userId);
              if (user == null) return const SizedBox();
              return Chip(
                label: Text('${user.nama} (${user.email})', style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => controller.toggleUserSelection(userId),
                backgroundColor: const Color(0xFFE5E7EB),
                padding: const EdgeInsets.all(4),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              hint: const Text('Tambah Karyawan...'),
              value: null,
              items: controller.userList
                .where((u) => !controller.selectedUserIds.contains(u.id))
                .map((e) => DropdownMenuItem(value: e.id, child: Text('${e.nama} (${e.email})')))
                .toList(),
              onChanged: (val) {
                if (val != null) controller.toggleUserSelection(val);
              },
            ),
          )
        ],
      )
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF374151)));
  }

  Widget _buildDropdownSearch<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE2E5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
