import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pelaksanaan_sop_controller.dart';
import 'package:app_sop/app/data/models/sop_pelaksanaan_model.dart';
import 'package:intl/intl.dart';

class PelaksanaanSopView extends GetView<PelaksanaanSopController> {
  const PelaksanaanSopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToolbar(context),
                    const SizedBox(height: 20),
                    _buildFilterRow(),
                    const SizedBox(height: 12),
                    _buildListContent(context),
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
            'Pelaksanaan SOP',
            style: TextStyle(fontSize: 14, color: Color(0xFF7E8494)),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showFormDialog(context),
      icon: const Icon(Icons.add, size: 18),
      label: const Text('TAMBAH PELAKSANAAN', style: TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF242B42),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDDE2E5)),
            borderRadius: BorderRadius.circular(4),
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
                      controller.fetchPelaksanaans();
                    }
                  },
                )),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller.searchController,
              onSubmitted: (_) => controller.fetchPelaksanaans(),
              decoration: InputDecoration(
                hintText: 'Cari Pelaksanaan...',
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFFDDE2E5)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.pelaksanaanList.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
      }

      if (controller.pelaksanaanList.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Data pelaksanaan tidak ditemukan')),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.pelaksanaanList.length,
        itemBuilder: (context, index) {
          return _buildPelaksanaanCard(context, controller.pelaksanaanList[index], index + 1);
        },
      );
    });
  }

  Widget _buildPelaksanaanCard(BuildContext context, SopPelaksanaanModel item, int no) {
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
                  item.sop?.kode ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 13),
                ),
                const Spacer(),
                _buildActionButton(Icons.visibility_outlined, Colors.cyan, () => _showDetailDialog(context, item)),
                const SizedBox(width: 8),
                _buildActionButton(Icons.edit_outlined, Colors.orange, () => _showFormDialog(context, pelaksanaan: item)),
                const SizedBox(width: 8),
                _buildActionButton(Icons.delete_outline, Colors.red, () => controller.deletePelaksanaan(item.id!)),
              ],
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _infoColumn('SOP', item.sop?.nama ?? '-', isBold: true),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const Text('PERIODE', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      _statusBadge(_getStatusLabel(item.statusSop)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _infoColumn('PELAKSANA', item.user?.nama ?? '-', icon: Icons.person_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _infoColumn('RUANG', item.ruang?.nama ?? '-'),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('POIN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.green,
                        child: Text('${item.poin ?? 0}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _infoColumn('DEADLINE', _formatTimestamp(item.deadlineWaktu)),
                ),
                Expanded(
                  child: _infoColumn('WAKTU SELESAI', _formatTimestamp(item.waktuSelesai)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
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

  Widget _infoColumn(String label, String value, {bool isBold = false, IconData? icon}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.blue),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: const Color(0xFF343A40),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(String label) {
    Color color = Colors.orange;
    if (label == 'Mingguan') color = Colors.cyan;
    if (label == 'Bulanan') color = Colors.orange;
    if (label == 'Tahunan') color = Colors.purple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getStatusLabel(int? status) {
    switch (status) {
      case 0: return 'Harian';
      case 1: return 'Mingguan';
      case 2: return 'Bulanan';
      case 3: return 'Tahunan';
      default: return '-';
    }
  }

  String _formatTimestamp(int? ts) {
    if (ts == null) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  void _showDetailDialog(BuildContext context, SopPelaksanaanModel item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Detail Pelaksanaan SOP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                    border: TableBorder.all(color: Colors.grey.withOpacity(0.2)),
                    children: [
                      _detailRow('SOP', '[${item.sop?.kode ?? "-"}] ${item.sop?.nama ?? "-"}'),
                      _detailRow('Langkah', item.langkah?.deskripsiLangkah ?? '-'),
                      _detailRow('Pelaksana', item.user?.nama ?? '-'),
                      _detailRow('Area', item.area?.nama ?? '-'),
                      _detailRow('Ruang', item.ruang?.nama ?? '-'),
                      _detailRow('Periode', _getStatusLabel(item.statusSop)),
                      _detailRow('Poin', '${item.poin ?? 0}'),
                      _detailRow('Deadline', _formatTimestamp(item.deadlineWaktu)),
                      _detailRow('Toleransi Sebelum', _formatTimestamp(item.toleransiWaktuSebelum)),
                      _detailRow('Toleransi Sesudah', _formatTimestamp(item.toleransiWaktuSesudah)),
                      _detailRow('Waktu Mulai', _formatTimestamp(item.waktuMulai)),
                      _detailRow('Waktu Selesai', _formatTimestamp(item.waktuSelesai)),
                      _detailRow('Bukti (URL)', item.url ?? '-'),
                      _detailRow('Deskripsi', item.des ?? '-'),
                      _detailRow('Dibuat', item.createdAt ?? '-'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(closeOverlays: true),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _detailRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(value),
        ),
      ],
    );
  }

  void _showFormDialog(BuildContext context, {SopPelaksanaanModel? pelaksanaan}) {
    controller.openFormDialog(pelaksanaan: pelaksanaan);

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
              // Header
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
                    Text(
                      pelaksanaan == null ? 'Tambah Pelaksanaan SOP' : 'Edit Pelaksanaan SOP',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () => Get.back(closeOverlays: true), icon: const Icon(Icons.close, size: 20)),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('SOP *'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedSopId.value,
                        hint: '-- Pilih SOP --',
                        items: controller.sopList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nama ?? '-'))).toList(),
                        onChanged: (val) => controller.onSopChanged(val),
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Langkah SOP'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedLangkahId.value,
                        hint: '-- Pilih Langkah (Opsional) --',
                        items: controller.langkahList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.deskripsiLangkah ?? '-'))).toList(),
                        onChanged: (val) => controller.selectedLangkahId.value = val,
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Pelaksana *'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedUserId.value,
                        hint: '-- Pilih Pelaksana --',
                        items: controller.userList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nama ?? '-'))).toList(),
                        onChanged: (val) => controller.selectedUserId.value = val,
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Periode SOP'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedStatusSop.value,
                        hint: '-- Pilih Periode --',
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Harian')),
                          DropdownMenuItem(value: 1, child: Text('Mingguan')),
                          DropdownMenuItem(value: 2, child: Text('Bulanan')),
                          DropdownMenuItem(value: 3, child: Text('Tahunan')),
                        ],
                        onChanged: (val) => controller.selectedStatusSop.value = val,
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Area'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedAreaId.value,
                        hint: '-- Pilih Area --',
                        items: controller.areaList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nama ?? '-'))).toList(),
                        onChanged: (val) => controller.selectedAreaId.value = val,
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Ruang'),
                      Obx(() => _dropdown<int>(
                        value: controller.selectedRuangId.value,
                        hint: '-- Pilih Ruang --',
                        items: controller.ruangList.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nama ?? '-'))).toList(),
                        onChanged: (val) => controller.selectedRuangId.value = val,
                      )),
                      const SizedBox(height: 16),
                      _fieldLabel('Deadline Waktu'),
                      _dateTimePicker(controller.deadlineWaktuController),
                      const SizedBox(height: 16),
                      _fieldLabel('Toleransi Sebelum'),
                      _dateTimePicker(controller.toleransiSebelumController),
                      const SizedBox(height: 16),
                      _fieldLabel('Toleransi Sesudah'),
                      _dateTimePicker(controller.toleransiSesudahController),
                      const SizedBox(height: 16),
                      _fieldLabel('Waktu Mulai'),
                      _dateTimePicker(controller.waktuMulaiController),
                      const SizedBox(height: 16),
                      _fieldLabel('Waktu Selesai'),
                      _dateTimePicker(controller.waktuSelesaiController),
                      const SizedBox(height: 16),
                      _fieldLabel('Poin'),
                      _textField(controller.poinController, '0', isNumber: true),
                      const SizedBox(height: 16),
                      _fieldLabel('URL Bukti (Foto/Video)'),
                      _textField(controller.urlBuktiController, 'https://...'),
                      const SizedBox(height: 16),
                      _fieldLabel('Deskripsi/Catatan'),
                      _textField(controller.desController, 'Catatan pelaksanaan...', maxLines: 3),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(closeOverlays: true), child: const Text('Batal')),
                    const SizedBox(width: 12),
                    Obx(() => ElevatedButton(
                      onPressed: controller.isSubmitting.value ? null : () => controller.submitForm(pelaksanaan: pelaksanaan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pelaksanaan == null ? const Color(0xFF2D5BD0) : Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(controller.isSubmitting.value ? 'Loading...' : (pelaksanaan == null ? 'SIMPAN' : 'Update')),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFDDE2E5))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFDDE2E5))),
      ),
    );
  }

  Widget _dateTimePicker(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: Get.context!,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            ctrl.text = DateFormat('dd/MM/yyyy HH:mm').format(combined);
          }
        }
      },
      decoration: InputDecoration(
        hintText: 'dd/mm/yyyy --:--',
        suffixIcon: const Icon(Icons.calendar_today, size: 16),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFDDE2E5))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFDDE2E5))),
      ),
    );
  }

  Widget _dropdown<T>({required T? value, required String hint, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    // Safety check: if value is not null but also not in items, set it to null or show a dummy item to prevent crash
    bool valueExists = items.any((item) => item.value == value);
    T? effectiveValue = valueExists ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFDDE2E5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: effectiveValue,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14)),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
