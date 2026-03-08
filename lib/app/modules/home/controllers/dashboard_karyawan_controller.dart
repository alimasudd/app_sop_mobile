import 'package:get/get.dart';
import 'package:app_sop/app/data/providers/api_provider.dart';

class DashboardKaryawanController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Data from API
  final userData = {}.obs;
  final summaryData = {}.obs;
  final tugasHariIni = [].obs;
  final aktivitasHariIni = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await _apiProvider.getDashboardKaryawan();
      
      if (data.containsKey('user')) {
        userData.value = data['user'] as Map<String, dynamic>;
      }
      
      if (data.containsKey('summary')) {
        summaryData.value = data['summary'] as Map<String, dynamic>;
      }
      
      if (data.containsKey('tugas_hari_ini')) {
        tugasHariIni.value = data['tugas_hari_ini'] as List<dynamic>;
      }
      
      if (data.containsKey('aktivitas_hari_ini')) {
        aktivitasHariIni.value = data['aktivitas_hari_ini'] as List<dynamic>;
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
