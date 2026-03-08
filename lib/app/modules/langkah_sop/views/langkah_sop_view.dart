import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/langkah_sop_controller.dart';
import 'package:app_sop/app/routes/app_pages.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';

class LangkahSopView extends GetView<LangkahSopController> {
  const LangkahSopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header Content
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  const Text(
                    'Master Data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF242B42)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Langkah SOP',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7E8494)),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Card
                    _buildFilterCard(),
                    const SizedBox(height: 20),
                    
                    // Toolbar
                    _buildToolbar(context),
                    const SizedBox(height: 20),
                    
                    // Table Card
                    _buildTableCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(top: BorderSide(color: Color(0xFF2D5BD0), width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => controller.isFilterExpanded.toggle(),
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 20, color: Color(0xFF4B5563)),
                const SizedBox(width: 8),
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                ),
                const Spacer(),
                Obx(() => Icon(
                  controller.isFilterExpanded.value ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF4B5563),
                )),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isFilterExpanded.value) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 600;
                    return Flex(
                      direction: isSmall ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: isSmall ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: isSmall ? 0 : 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pilih SOP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                              const SizedBox(height: 8),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFDDE2E5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    hint: const Text('Semua SOP'),
                                    value: controller.filterSopId.value,
                                    items: controller.sopList.map((e) {
                                      return DropdownMenuItem<int>(
                                        value: e.id,
                                        child: Text('[${e.kode ?? "-"}] ${e.nama ?? "-"}', overflow: TextOverflow.ellipsis),
                                      );
                                    }).toList(),
                                    onChanged: (val) => controller.filterSopId.value = val,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmall ? 0 : 16, height: isSmall ? 16 : 0),
                        Expanded(
                          flex: isSmall ? 0 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Wajib', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                              const SizedBox(height: 8),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFDDE2E5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    hint: const Text('Semua'),
                                    value: controller.filterWajib.value,
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text('Ya - Langkah Wajib')),
                                      DropdownMenuItem(value: 0, child: Text('Tidak - Opsional')),
                                    ],
                                    onChanged: (val) => controller.filterWajib.value = val,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmall ? 0 : 16, height: isSmall ? 16 : 0),
                        ElevatedButton.icon(
                          onPressed: () => controller.fetchLangkah(),
                          icon: const Icon(Icons.search, size: 16),
                          label: const Text('FILTER'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D5BD0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => controller.resetFilter(),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Reset'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4B5563),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 8.0, // gap between lines
      alignment: WrapAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showFormDialog(context),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('TAMBAH LANGKAH', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D5BD0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().changeIndex(13);
            } else {
              if (Get.currentRoute == Routes.LANGKAH_SOP) {
                 Get.offNamed(Routes.HOME);
              } else {
                 Get.offNamed(Routes.SOP);
              }
            }
          },
          icon: const Icon(Icons.file_copy_outlined, size: 16),
          label: const Text('Kelola SOP', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C6FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().changeIndex(12);
            } else {
              if (Get.currentRoute == Routes.LANGKAH_SOP) {
                 Get.offNamed(Routes.HOME);
              } else {
                 Get.offNamed(Routes.KATEGORI_SOP);
              }
            }
          },
          icon: const Icon(Icons.folder_outlined, size: 16),
          label: const Text('Kelola Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF3F4F6),
            foregroundColor: const Color(0xFF4B5563),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCard(BuildContext context) {
    return Column(
      children: [
        // Show Entries placeholder
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
                      controller.fetchLangkah();
                    }
                  },
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.filterSearchController,
                onChanged: (val) {
                  // simple debounce logic or just call
                  controller.fetchLangkah();
                },
                decoration: InputDecoration(
                  hintText: 'Cari Langkah...',
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
        const SizedBox(height: 12),

        // List View equivalent to Area/Ruang/KategoriSop
        Obx(() {
          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.langkahList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('Data langkah tidak ditemukan')),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.langkahList.length,
            itemBuilder: (context, index) {
              return _buildLangkahCard(context, controller.langkahList[index], index + 1);
            },
          );
        }),
      ],
    );
  }

  Widget _buildLangkahCard(BuildContext context, SopLangkahModel item, int no) {
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
                  item.sop?['kode'] ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 13),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.edit_note,
                  color: Colors.orange,
                  label: 'Edit',
                  onTap: () => _showFormDialog(context, langkah: item),
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  label: 'Hapus',
                  onTap: () => controller.deleteLangkah(item.id!),
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
                      const Text('SOP & DESKRIPSI', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        item.sop?['nama'] ?? '-',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF343A40)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.deskripsiLangkah ?? '-',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
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
                      _infoBadge('URUTAN', '${item.urutan ?? 0}', Colors.purple),
                      _infoColumn('RUANG', item.ruang?['nama'] ?? '-', const Color(0xFF2575FC)),
                      _infoColumn('PIC', item.userId != null ? (item.user?['nama'] ?? '-') : '- Semua -', Colors.orange),
                      _infoColumn('WAJIB', item.wajib == 1 ? 'Ya' : 'Tdk', item.wajib == 1 ? Colors.green : Colors.grey),
                      _infoBadge('POIN', '${item.poin ?? 0}', Colors.green),
                      _infoColumn('REMINDER', item.waReminder == 1 ? (item.waJamKirim ?? 'On') : 'Off', item.waReminder == 1 ? Colors.green : Colors.grey),
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

  Widget _infoColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: Text(
            value, 
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _infoBadge(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }


  void _showFormDialog(BuildContext context, {var langkah}) {
    controller.openFormDialog(langkah: langkah);
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 800,
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF374151)),
                        const SizedBox(width: 8),
                        Text(
                          langkah == null ? 'Tambah Langkah SOP' : 'Edit Langkah SOP',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      icon: const Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Dialog Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Pilih SOP *'),
                                const SizedBox(height: 8),
                                Obx(() => _dropdown<int>(
                                  value: controller.selectedSopId.value,
                                  hint: '-- Pilih SOP --',
                                  items: controller.sopList.map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text('[${e.kode ?? "-"}] ${e.nama ?? "-"}', overflow: TextOverflow.ellipsis),
                                  )).toList(),
                                  onChanged: (val) => controller.onSopSelectedForForm(val),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Urutan *'),
                                const SizedBox(height: 8),
                                _textField(controller.urutanController, '1', isNumber: true),
                                const SizedBox(height: 4),
                                const Text('Otomatis diisi saat pilih SOP', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      _label('Ruang'),
                      const SizedBox(height: 8),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedRuangId.value,
                        hint: '-- Pilih Ruang (Opsional) --',
                        items: controller.ruangList.map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text('[${e.area?.nama ?? "Area"}] ${e.nama ?? "-"}', overflow: TextOverflow.ellipsis),
                        )).toList(),
                        onChanged: (val) => controller.selectedRuangId.value = val,
                      )),
                      const SizedBox(height: 4),
                      const Text('Pilih ruang tempat langkah ini dilakukan', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      
                      const SizedBox(height: 16),
                      _label('Deskripsi Langkah *'),
                      const SizedBox(height: 8),
                      _textField(controller.deskripsiController, 'Deskripsi detail langkah SOP', maxLines: 3),
                      
                      const SizedBox(height: 16),
                      _label('Penanggung Jawab (User)'),
                      const SizedBox(height: 8),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedUserId.value,
                        hint: '-- Semua User / Belum Ditentukan --',
                        items: controller.userList.map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.nama ?? "-"} (${e.email ?? "-"})', overflow: TextOverflow.ellipsis),
                        )).toList(),
                        onChanged: (val) => controller.selectedUserId.value = val,
                      )),
                      const SizedBox(height: 4),
                      const Text('Pilih user yang bertanggung jawab mengerjakan langkah ini', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Wajib'),
                                const SizedBox(height: 8),
                                Obx(() => _dropdown<int>(
                                  value: controller.selectedWajib.value,
                                  hint: '',
                                  items: const [
                                    DropdownMenuItem(value: 1, child: Text('Ya - Langkah Wajib')),
                                    DropdownMenuItem(value: 0, child: Text('Tidak - Opsional')),
                                  ],
                                  onChanged: (val) => controller.selectedWajib.value = val ?? 1,
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Poin'),
                                const SizedBox(height: 8),
                                _textField(controller.poinController, '10', isNumber: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: const [
                          Icon(Icons.access_time, size: 18, color: Color(0xFF374151)),
                          SizedBox(width: 8),
                          Text('Pengaturan Waktu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Deadline Waktu'),
                          const SizedBox(height: 8),
                          _textField(controller.deadlineController, 'dd/mm/yyyy --:--', icon: Icons.calendar_today),
                          const SizedBox(height: 16),
                          _label('Toleransi Sebelum'),
                          const SizedBox(height: 8),
                          _textField(controller.toleransiSebelumController, 'dd/mm/yyyy --:--', icon: Icons.calendar_today),
                          const SizedBox(height: 4),
                          const Text('Batas waktu mulai sebelum deadline', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 16),
                          _label('Toleransi Sesudah'),
                          const SizedBox(height: 8),
                          _textField(controller.toleransiSesudahController, 'dd/mm/yyyy --:--', icon: Icons.calendar_today),
                          const SizedBox(height: 4),
                          const Text('Batas waktu selesai sesudah deadline', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Row(
                         children: const [
                            Icon(Icons.message, size: 18, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Reminder WhatsApp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                         ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                            value: controller.isWaReminder.value,
                            onChanged: (val) => controller.isWaReminder.value = val ?? false,
                            activeColor: Colors.green,
                          )),
                          const Text('Kirim Reminder WhatsApp', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 48.0),
                        child: Text(
                          'Centang untuk mengirim reminder WA otomatis kepada penanggung jawab',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Dialog Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      child: const Text('Batal', style: TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => ElevatedButton.icon(
                      onPressed: controller.isSubmitting.value ? null : () => controller.submitForm(langkah: langkah),
                      icon: controller.isSubmitting.value 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save, size: 16),
                      label: Text(langkah == null ? 'SIMPAN' : 'UPDATE', style: const TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: langkah == null ? const Color(0xFF2D5BD0) : Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _label(String text) {
    bool isRequired = text.contains('*');
    if (isRequired) {
      List<String> parts = text.split('*');
      return RichText(
        text: TextSpan(
          text: parts[0],
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
          children: const [
            TextSpan(text: '*', style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151)));
  }

  Widget _textField(TextEditingController controller, String hint, {int maxLines = 1, bool isNumber = false, IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE2E5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    // Check if the current value exists in the items list to prevent assertion error
    T? safeValue = value;
    if (safeValue != null) {
      var itemExists = items.any((item) => item.value == safeValue);
      if (!itemExists) {
        safeValue = null; // Reset to null if value is not in the list
      }
    }

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
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          value: safeValue,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
