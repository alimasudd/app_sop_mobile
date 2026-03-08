import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/data/models/tugas_sop_model.dart';
import 'package:app_sop/app/modules/tugas_sop/controllers/tugas_sop_controller.dart';
import 'package:app_sop/app/data/providers/confirm_dialog.dart';
import 'package:intl/intl.dart';

class TugasSopView extends GetView<TugasSopController> {
  const TugasSopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Content
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoBox(),
                    _buildToolbar(),
                    Obx(() {
                      if (controller.isLoading.value && controller.tugasSops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }
                      
                      if (controller.tugasSops.isEmpty) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Data penugasan tidak ditemukan')));
                      }
        
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.tugasSops.length,
                        itemBuilder: (context, index) {
                          return _buildTugasCard(controller.tugasSops[index], index + 1);
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

  // ... (Header, InfoBox, Toolbar stay similar with previous layout fixes)

  Widget _buildTugasCard(TugasSopModel item, int no) {
    String kode = item.sop?['kode'] ?? '-';
    String namaSop = item.sop?['nama'] ?? '-';
    String kategoriName = item.sop?['kategori']?['nama'] ?? '-';
    bool isSemua = item.langkah == null;
    String langkahText = isSemua ? 'Semua Langkah' : 'Langkah #${item.langkah?['urutan'] ?? '?'}';
    String langkahSubtext = isSemua ? '' : (item.langkah?['deskripsi_langkah'] ?? '');
    String userNama = item.user?['nama'] ?? '-';
    String userHp = item.user?['hp'] ?? '-';

    String tanggal = '-';
    if (item.createdAt != null) {
      try {
        DateTime dt = DateTime.parse(item.createdAt!);
        tanggal = DateFormat('dd/MM/yyyy HH:mm').format(dt);
      } catch (e) {
        tanggal = item.createdAt!;
      }
    }

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
                    color: Colors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('No: $no', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B4EAA))),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF00C7E6), borderRadius: BorderRadius.circular(4)),
                  child: Text(kategoriName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => controller.deleteTugas(item.id!),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  tooltip: 'Hapus Penugasan',
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SOP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(kode, style: const TextStyle(color: Colors.pink, fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(namaSop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF343A40))),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DITUGASKAN KEPADA', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(child: Text(userNama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(userHp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CAKUPAN LANGKAH', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSemua ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(langkahText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      if (!isSemua && langkahSubtext.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(langkahSubtext, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('WAKTU PENUGASAN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(tanggal, style: const TextStyle(fontSize: 13, color: Color(0xFF343A40))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFormDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 500, // Fixed width to prevent jumping and squeezes
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          padding: const EdgeInsets.all(24),
          child: Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(controller.isMassal.value ? Icons.people : Icons.add_circle, color: const Color(0xFF343A40)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.isMassal.value ? 'Penugasan SOP Massal' : 'Tambah Penugasan SOP',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  ],
                ),
                const Divider(height: 32),
                
                // VERTICAL LAYOUT for Inputs to prevent squeezing
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
                
                const SizedBox(height: 20),
                _label(controller.isMassal.value ? 'Pilih Karyawan * (Bisa Multi-select)' : 'Pilih Karyawan *'),
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

                const SizedBox(height: 20),
                _label('Ditugaskan Pada *'),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Semua Langkah SOP', style: TextStyle(fontSize: 14)),
                  value: 'semua',
                  groupValue: controller.ditugaskanPada.value,
                  onChanged: (val) => controller.ditugaskanPada.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF1B4EAA),
                ),
                RadioListTile<String>(
                  title: const Text('Langkah Tertentu', style: TextStyle(fontSize: 14)),
                  value: 'tertentu',
                  groupValue: controller.ditugaskanPada.value,
                  onChanged: (val) => controller.ditugaskanPada.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF1B4EAA),
                ),

                if (controller.ditugaskanPada.value == 'tertentu') ...[
                  const SizedBox(height: 12),
                  _buildDropdownSearch<int>(
                    hint: 'Pilih Langkah...',
                    value: controller.selectedLangkahId.value,
                    items: controller.langkahSopList.map((e) => DropdownMenuItem(value: e.id, child: Text('Langkah #${e.urutan}: ${e.deskripsiLangkah}'))).toList(),
                    onChanged: (val) {
                      controller.selectedLangkahId.value = val;
                    },
                  ),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isSaving.value ? null : () => controller.submitAssignment(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isMassal.value ? const Color(0xFF00C897) : const Color(0xFF1B4EAA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      controller.isSaving.value 
                        ? 'LOADING...' 
                        : (controller.isMassal.value ? 'SIMPAN PENUGASAN MASSAL' : 'SIMPAN PENUGASAN'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  )),
                ),
              ],
            ),
          )),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ... (Header info remains the same)
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
            'Tugas SOP',
            style: TextStyle(fontSize: 14, color: Color(0xFF7E8494)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00C7E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.isInfoExpanded.toggle(),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text('Informasi Penugasan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Obx(() => Icon(
                  controller.isInfoExpanded.value ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                )),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isInfoExpanded.value) return const SizedBox.shrink();
            return Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'Halaman ini digunakan untuk menugaskan karyawan pada SOP tertentu. Anda bisa menugaskan karyawan ke seluruh langkah dalam SOP, atau langkah tertentu saja.',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            );
          }),
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
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedUserIds.map((userId) {
              final user = controller.userList.firstWhereOrNull((u) => u.id == userId);
              if (user == null) return const SizedBox();
              return Chip(
                label: Text(user.nama ?? '', style: const TextStyle(fontSize: 11)),
                deleteIcon: const Icon(Icons.close, size: 14),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onDeleted: () => controller.toggleUserSelection(userId),
                backgroundColor: const Color(0xFFE5E7EB),
              );
            }).toList(),
          )),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              hint: const Text('Tambah Karyawan...', style: TextStyle(fontSize: 13)),
              value: null,
              items: controller.userList
                .where((u) => !controller.selectedUserIds.contains(u.id))
                .map((e) => DropdownMenuItem(value: e.id, child: Text('${e.nama} (${e.email})', style: const TextStyle(fontSize: 13))))
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
          hint: Text(hint, style: const TextStyle(fontSize: 13)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
