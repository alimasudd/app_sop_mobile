import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/tugas_saya_controller.dart';
import 'package:intl/intl.dart';

class TugasSayaView extends StatelessWidget {
  const TugasSayaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lazily put controller
    final controller = Get.put(TugasSayaController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background like in image
      body: Obx(() {
        if (controller.isLoading.value && controller.tugasHariIni.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.tugasHariIni.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchTugasData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final summary = controller.summaryData;

        return RefreshIndicator(
          onRefresh: controller.fetchTugasData,
          color: const Color(0xFF6A11CB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildStatCardsRow(summary),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 16),
                _buildTabContent(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard() {
    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy', 'en_US');
    final todayStr = dateFormatter.format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF7b74e8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7b74e8).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 14),
              const SizedBox(width: 8),
              Text(
                todayStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.assignment, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Tugas Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Pusat kendali tugas SOP — Penugasan, Jadwal Pelaksanaan, dan Progress harian Anda',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardsRow(Map summary) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatCard(
              title: 'Jadwal Pelaksanaan',
              value: '${summary['jadwal_pelaksanaan'] ?? 0}',
              icon: Icons.calendar_month,
              color: const Color(0xFF0ea5e9), // Light blue
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              title: 'Total Langkah\nHari Ini',
            value: '${summary['total_langkah'] ?? 0}',
            icon: Icons.list_alt,
            color: const Color(0xFF7e57c2), // Purple 
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Selesai',
            value: '${summary['selesai'] ?? 0}',
            icon: Icons.check_circle_outline,
            color: const Color(0xFF10B981), // Emerald/Green
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Dikerjakan',
            value: '${summary['dikerjakan'] ?? 0}',
            icon: Icons.pending_actions,
            color: const Color(0xFFF59E0B), // Amber/Orange
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Belum',
            value: '${summary['belum'] ?? 0}',
            icon: Icons.access_time_filled,
            color: const Color(0xFFEF4444), // Red
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Poin Hari Ini',
            value: '${summary['poin_hari_ini'] ?? 0}',
            icon: Icons.star,
            color: const Color(0xFF8B5CF6), // Purple
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: Colors.white.withOpacity(0.4), size: 32),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalPelaksanaanBlueCard(Map summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0ea5e9), // Light blue
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0ea5e9).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${summary['jadwal_pelaksanaan'] ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Jadwal Pelaksanaan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Icon(Icons.calendar_month, color: Colors.white.withOpacity(0.5), size: 36),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final controller = Get.find<TugasSayaController>();

    return Obx(() {
      int tugasCount = controller.tugasHariIni.length;
      int jadwalCount = controller.summaryData['jadwal_pelaksanaan'] ?? 0;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                title: 'Tugas Hari Ini',
                count: tugasCount,
                isSelected: controller.selectedTab.value == 0,
                onTap: () => controller.ubahTab(0),
                icon: Icons.list,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                title: 'Jadwal Pelaksanaan',
                count: jadwalCount,
                isSelected: controller.selectedTab.value == 1,
                onTap: () => controller.ubahTab(1),
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabButton({required String title, required int count, required bool isSelected, required VoidCallback onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B66FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final controller = Get.find<TugasSayaController>();

    return Obx(() {
      if (controller.selectedTab.value == 0) {
        return _buildTugasList();
      } else {
        return _buildJadwalList();
      }
    });
  }

  Widget _buildJadwalList() {
    final controller = Get.find<TugasSayaController>();

    if (controller.jadwalPelaksanaan.isEmpty) {
      return _buildJadwalEmptyState();
    }

    return Column(
      children: controller.jadwalPelaksanaan.map<Widget>((sop) => _buildSopCard(sop)).toList(),
    );
  }

  Widget _buildJadwalEmptyState() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_month, size: 48, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Jadwal Pelaksanaan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'Belum ada jadwal pelaksanaan SOP untuk Anda saat ini.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasList() {
    final controller = Get.find<TugasSayaController>();

    if (controller.tugasHariIni.isEmpty) {
      return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
              SizedBox(height: 16),
              Text(
                'Semua Tugas Selesai',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Tidak ada tugas SOP yang tertunda hari ini.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: controller.tugasHariIni.map<Widget>((sop) => _buildSopCard(sop)).toList(),
    );
  }

  Widget _buildSopCard(Map sop) {
    Map progress = sop['progress'] ?? {};
    int percentage = progress['percentage'] ?? 0;
    int total = progress['total_langkah'] ?? 0;
    int selesai = progress['selesai'] ?? 0;
    int dikerjakan = progress['dikerjakan'] ?? 0;
    int belum = progress['belum'] ?? 0;
    List langkah = sop['langkah'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_offer, size: 12, color: Color(0xFF6B66FF)),
                        const SizedBox(width: 4),
                        Text(
                          '${sop['kode']} • -',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B66FF), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sop['nama'] ?? '-',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sop['kategori_nama'] ?? 'Kategori',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              // Progress Badges & Bar Next to Arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      if (selesai > 0) _buildBadge(Icons.check, '$selesai', Colors.green),
                      if (dikerjakan > 0) _buildBadge(Icons.sync, '$dikerjakan', Colors.orange),
                      if (belum > 0) _buildBadge(Icons.access_time_filled, '$belum', Colors.red),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$selesai/$total',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: total > 0 ? (selesai / total) : 0,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6A11CB)),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$percentage%',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: langkah.length,
              itemBuilder: (context, index) {
                return _buildLangkahItem(langkah[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildLangkahItem(Map langkah) {
    final status = langkah['status'] ?? 'belum_dikerjakan'; // 'selesai', 'sedang_dikerjakan', 'belum_dikerjakan'
    final controller = Get.find<TugasSayaController>();

    Color circleColor = Colors.orange;
    if (status == 'selesai') circleColor = Colors.green;
    if (status == 'belum_dikerjakan') circleColor = Colors.grey[400]!;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Number
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${langkah['urutan'] ?? '-'}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            langkah['deskripsi_langkah'] ?? '-',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.business, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      langkah['ruang_nama'] ?? '-',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${langkah['poin']} poin',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(
                                (langkah['wajib'] == 1 || langkah['wajib'] == true) ? 'Wajib' : 'Opsional',
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: (langkah['wajib'] == 1 || langkah['wajib'] == true) ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Mulai Box if In Progress
                          if (status == 'sedang_dikerjakan' && langkah['waktu_mulai'] != null)
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1), // Light yellow
                                borderRadius: BorderRadius.circular(4),
                                border: const Border(left: BorderSide(color: Colors.orange, width: 3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.sync, size: 12, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Mulai jam ${langkah['waktu_mulai']}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Action Butto & Label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildStatusLabel(status),
                        const SizedBox(height: 8),
                        _buildActionButton(status, langkah['id'], controller),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusLabel(String status) {
    String text = 'Belum';
    Color color = Colors.grey;
    Color bgColor = Colors.transparent;

    if (status == 'selesai') {
      text = ''; // usually hidden or no badge above action button if done? wait picture doesn't show badge if done.
    } else if (status == 'sedang_dikerjakan') {
      text = 'Dikerjakan';
      color = Colors.orange;
      bgColor = Colors.orange.withOpacity(0.1);
    } else {
      text = 'Belum';
      color = Colors.grey;
      bgColor = Colors.grey.withOpacity(0.1);
    }

    if (text.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sync, size: 10, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String status, int langkahId, TugasSayaController controller) {
    if (status == 'selesai') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent, // or Colors.green? Wait the design shows no button, just checked. Let's make it a green label
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: Colors.green),
            SizedBox(width: 4),
            Text('Selasai', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      );
    } else if (status == 'sedang_dikerjakan') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981), // Green
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 32),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
        ),
        onPressed: () => controller.selesaikanTugas(langkahId),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text('Selesaikan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else {
      // Belum dikerjakan
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0ea5e9), // Light Blue
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 32),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
        ),
        onPressed: () => controller.mulaiTugas(langkahId),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text('Mulai', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
  }
}
