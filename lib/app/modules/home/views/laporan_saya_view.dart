import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/laporan_saya_controller.dart';
import 'package:intl/intl.dart';

class LaporanSayaView extends StatelessWidget {
  const LaporanSayaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaporanSayaController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      body: Obx(() {
        if (controller.isLoading.value && controller.riwayatList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.riwayatList.isEmpty) {
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
                  onPressed: controller.fetchLaporanData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final summary = controller.summaryData;
        final riwayat = controller.riwayatList;

        return RefreshIndicator(
          onRefresh: controller.fetchLaporanData,
          color: const Color(0xFF6A11CB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildFilterCard(context, controller),
                const SizedBox(height: 16),
                _buildStatCardsRow(summary),
                const SizedBox(height: 24),
                _buildRiwayatList(riwayat),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2d3748), // Dark color like web
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.library_books, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Laporan Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Riwayat pelaksanaan tugas SOP Anda — hanya lihat, tidak bisa edit atau hapus',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(BuildContext context, LaporanSayaController controller) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Tanggal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => controller.selectDateRange(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6B66FF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() {
                        final start = controller.startDate.value;
                        final end = controller.endDate.value;
                        final formatter = DateFormat('dd/MM/yyyy');
                        String text = 'Pilih Periode';
                        if (start != null && end != null) {
                          text = '${formatter.format(start)} s/d ${formatter.format(end)}';
                        }
                        return Text(
                          text,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        );
                      }),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B66FF),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () => controller.fetchLaporanData(),
                icon: const Icon(Icons.search, size: 18, color: Colors.white),
                label: const Text('Tampilkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardsRow(Map summary) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Langkah Selesai',
          value: '${summary['langkah_selesai'] ?? 0}',
          icon: Icons.check_circle,
          color: const Color(0xFF10B981), // Emerald/Green
        ),
        _buildStatCard(
          title: 'Total Poin',
          value: '${summary['total_poin'] ?? 0}',
          icon: Icons.star,
          color: const Color(0xFF8B5CF6), // Purple
        ),
        _buildStatCard(
          title: 'Hari Aktif',
          value: '${summary['hari_aktif'] ?? 0}',
          icon: Icons.event_available,
          color: const Color(0xFF0EA5E9), // Light Blue
        ),
        _buildStatCard(
          title: 'SOP Dikerjakan',
          value: '${summary['sop_dikerjakan'] ?? 0}',
          icon: Icons.assignment,
          color: const Color(0xFFF59E0B), // Orange
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatList(List riwayatList) {
    if (riwayatList.isEmpty) {
      return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tidak Ada Riwayat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Belum ada laporan penyelesaian tugas pada rentang tanggal ini.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: riwayatList.map<Widget>((group) {
        return _buildRiwayatGroupCard(group);
      }).toList(),
    );
  }

  Widget _buildRiwayatGroupCard(Map group) {
    List items = group['items'] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tanggal (Ungu seperti web)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF6B66FF), // Ungu muda
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      group['tanggal_format'] ?? '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${group['selesai_count']} selesai',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${group['poin_date']} poin',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // List Item (Mobile version of table)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildRiwayatItemMobile(items[index], index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatItemMobile(Map item, int urutan) {
    bool isSelesai = item['status'] == 'Selesai';
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor urut bulat
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$urutan',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              
              // Konten Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SOP Info
                    Text(
                      item['sop_kode'] ?? '-',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B66FF), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['sop_nama'] ?? '-',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    
                    // Langkah Data
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50], // Background tipis abu list langkah
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['langkah_nama'] ?? '-',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.business, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['ruang_nama'] ?? '-',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                '${item['poin']}',
                                style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Footer Baris: Status & Timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelesai ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelesai ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelesai ? Icons.check_circle : Icons.sync, 
                                size: 12, 
                                color: isSelesai ? Colors.green : Colors.orange
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['status'] ?? 'Proses',
                                style: TextStyle(
                                  fontSize: 11, 
                                  fontWeight: FontWeight.bold, 
                                  color: isSelesai ? Colors.green : Colors.orange
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Timestamps
                        Row(
                          children: [
                            const Icon(Icons.play_arrow, size: 12, color: Colors.grey),
                            Text(
                              item['waktu_mulai'] ?? '-',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.stop, size: 12, color: Colors.grey),
                            Text(
                              item['waktu_selesai'] ?? '-',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Catatan Section jika ada
                    if (item['catatan'] != null && item['catatan'] != '-' && item['catatan'].toString().isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(4),
                          border: const Border(left: BorderSide(color: Colors.grey, width: 2)),
                        ),
                        child: Text(
                          'Catatan: ${item['catatan']}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[700], fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
