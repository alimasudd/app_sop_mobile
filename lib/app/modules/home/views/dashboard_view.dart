import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_sop/app/modules/home/controllers/home_controller.dart';

class DashboardView extends GetView<HomeController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          // const SizedBox(height: 24),
          // _buildChartsSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Manajemen SOP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            'Selamat datang, ${controller.userName.value}! Kelola SOP dengan mudah dan efisien.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 14),
                SizedBox(width: 8),
                Text(
                  'Saturday, 07 March 2026 • 16:39 WIB',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            Obx(() => _buildStatCard(
              title: 'TOTAL SOP',
              value: '${controller.totalSop.value}',
              subValue: '${controller.activeSop.value} Aktif',
              icon: Icons.description,
              color: const Color(0xFF6A11CB),
            )),
            Obx(() => _buildStatCard(
              title: 'LANGKAH SOP',
              value: '${controller.langkahSop.value}',
              subValue: '${controller.totalKategori.value} Kategori',
              icon: Icons.format_list_bulleted,
              color: const Color(0xFF03A9F4),
            )),
            Obx(() => _buildStatCard(
              title: 'PELAKSANAAN BULAN INI',
              value: '${controller.pelaksanaanBulanIni.value}',
              subValue: '${controller.totalPoin.value} Poin',
              icon: Icons.check_box,
              color: const Color(0xFF00C853),
            )),
            Obx(() => _buildStatCard(
              title: 'PENGGUNA AKTIF',
              value: '${controller.penggunaAktif.value}',
              subValue: '${controller.totalPenugasan.value} Penugasan',
              icon: Icons.people,
              color: const Color(0xFFFFA000),
            )),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subValue,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: color, width: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              subValue,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildChartContainer(
                  title: 'Pelaksanaan SOP 7 Hari Terakhir',
                  child: _buildSimpleLineChart(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildChartContainer(
                  title: 'SOP per Frekuensi',
                  child: _buildSimpleBarChart(),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildChartContainer(
                title: 'Pelaksanaan SOP 7 Hari Terakhir',
                child: _buildSimpleLineChart(),
              ),
              const SizedBox(height: 16),
              _buildChartContainer(
                title: 'SOP per Frekuensi',
                child: _buildSimpleBarChart(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSimpleLineChart() {
    return Container(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 10,
                      height: 50 + (index * 10), // Dummy height
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A11CB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      controller.chartDays[index],
                      style: TextStyle(fontSize: 8, color: Colors.grey[600]),
                    )),
                  ],
                );
              }),
            ),
          ),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               _LegendItem(color: Color(0xFF6A11CB), label: 'Pelaksanaan'),
               SizedBox(width: 16),
               _LegendItem(color: Colors.green, label: 'Poin', isBordered: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    return Container(
      height: 220, // Increased height
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: (controller.frequencyData).map((data) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 25,
                      height: (data['value'] as double) * 120, // Reduced scale
                      decoration: BoxDecoration(
                        color: data['color'] as Color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: (controller.frequencyData).map((data) {
              return _LegendItem(
                color: data['color'] as Color,
                label: data['label'] as String,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBordered;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isBordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isBordered ? Colors.transparent : color,
            border: isBordered ? Border.all(color: color, width: 2) : null,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}
