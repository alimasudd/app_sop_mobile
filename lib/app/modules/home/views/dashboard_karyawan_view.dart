import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/dashboard_karyawan_controller.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';

class DashboardKaryawanView extends StatelessWidget {
  const DashboardKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lazily put controller to manage state
    final controller = Get.put(DashboardKaryawanController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background like in image
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
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
                  onPressed: controller.fetchDashboardData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final user = controller.userData;
        final summary = controller.summaryData;
        final tugasHariIni = controller.tugasHariIni;
        final aktivitasHariIni = controller.aktivitasHariIni;

        return RefreshIndicator(
          onRefresh: controller.fetchDashboardData,
          color: const Color(0xFF6A11CB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(user, summary),
                const SizedBox(height: 16),
                _buildStatCardsRow(summary),
                const SizedBox(height: 24),
                _buildTugasSopHariIni(tugasHariIni),
                const SizedBox(height: 24),
                _buildAksiCepat(),
                const SizedBox(height: 24),
                _buildAktivitasHariIni(aktivitasHariIni),
                const SizedBox(height: 24),
                _buildTotalPoinBottomCard(summary),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(Map user, Map summary) {
    int percentage = summary['persentase_hari_ini'] ?? 0;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'SELAMAT MALAM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('👋', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user['nama'] ?? 'Karyawan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      user['email'] ?? 'karyawan@email.com',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        user['hari_ini'] ?? 'Tanggal',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Circular Progress indicator
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: CircularProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 6,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Hari Ini',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              title: 'Total Langkah',
            value: '${summary['total_langkah'] ?? 0}',
            icon: Icons.list_alt,
            color: const Color(0xFF6366F1), // Indigo/Purple
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Selesai Hari Ini',
            value: '${summary['selesai_hari_ini'] ?? 0}',
            icon: Icons.check_circle_outline,
            color: const Color(0xFF10B981), // Emerald/Green
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Sedang Dikerjakan',
            value: '${summary['sedang_dikerjakan'] ?? 0}',
            icon: Icons.pending_actions,
            color: const Color(0xFFF59E0B), // Amber/Orange
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Belum Dikerjakan',
            value: '${summary['belum_dikerjakan'] ?? 0}',
            icon: Icons.access_time,
            color: const Color(0xFFEF4444), // Red
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Poin Hari Ini',
            value: '${summary['poin_hari_ini'] ?? 0}',
            icon: Icons.star_border,
            color: const Color(0xFF8B5CF6), // Purple
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
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
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTugasSopHariIni(List tugas) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.list, color: Color(0xFF2575FC), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Tugas SOP Hari Ini',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Tugas menu view
                    if (Get.isRegistered<HomeController>()) {
                      Get.find<HomeController>().changeIndex(5);
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Kerjakan', style: TextStyle(color: Color(0xFF2575FC))),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_outlined, size: 16, color: Color(0xFF2575FC)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            if (tugas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Tidak ada tugas hari ini',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tugas.length,
                itemBuilder: (context, index) {
                  final item = tugas[index];
                  int pct = item['percentage'] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.only(left: 4),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.orange, width: 4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_offer_outlined, size: 14, color: Color(0xFF2575FC)),
                              const SizedBox(width: 4),
                              Text(
                                item['kode'] ?? '-',
                                style: const TextStyle(color: Color(0xFF2575FC), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['nama'] ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['progress_text'] ?? '0 langkah',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                '$pct%',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                pct == 100 ? Colors.green : const Color(0xFF6A11CB),
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAksiCepat() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFF2575FC), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Aksi Cepat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              icon: Icons.play_circle_fill,
              iconColor: const Color(0xFF4A65E6),
              title: 'Kerjakan Tugas',
              subtitle: 'Buka tugas hari ini',
              onTap: () {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().changeIndex(5);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.book,
              iconColor: const Color(0xFF4A65E6),
              title: 'Laporan Saya',
              subtitle: 'Lihat riwayat aktivitas',
              onTap: () {}, // Handle navigation to My Reports
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.vpn_key,
              iconColor: const Color(0xFF4A65E6),
              title: 'Ganti Password',
              subtitle: 'Ubah password akun',
              onTap: () {}, // Handle navigation to Change Password
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({required IconData icon, required Color iconColor, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                  )
                ]
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAktivitasHariIni(List aktivitas) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_filled, color: Color(0xFF2575FC), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Aktivitas Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (aktivitas.isEmpty)
              const Center(child: Text('Belum ada aktivitas', style: TextStyle(color: Colors.grey)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: aktivitas.length,
                itemBuilder: (context, index) {
                  final act = aktivitas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.sync, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act['kegiatan'] ?? '-',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: act['deskripsi'] ?? '-',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  children: [
                                    const TextSpan(text: ' • '),
                                    TextSpan(text: act['waktu'] ?? '-'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPoinBottomCard(Map summary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF7b74e8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            '${summary['total_poin_keseluruhan'] ?? 0}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Total Poin Keseluruhan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
