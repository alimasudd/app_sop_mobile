import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';
import 'package:app_sop/app/data/models/kategori_sop_model.dart';
import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';
import 'package:app_sop/app/data/models/tugas_sop_model.dart';
import 'package:app_sop/app/data/models/sop_pelaksanaan_model.dart';

class ApiProvider {
  // final String baseUrl = "https://cekdemo.com/ap/apisop/public/api";
  final String baseUrl = "http://192.168.1.5:80/api";

  // Health Check
  Future<http.Response> checkHealth() async {
    final response = await http.get(
      Uri.parse(baseUrl.replaceFirst('/api', '')), // Test the root URL
      headers: {'Accept': 'application/json'},
    );
    return response;
  }

  // Helper to get headers with token from SharedPreferences
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
  };
  }

  // Profile
  Future<http.Response> getProfile(String token) async {
    return await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }


  // Login
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  // Register
  Future<http.Response> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode(data),
    );
    return response;
  }

  // Get Users with search support
  Future<List<UserModel>> getUsers({String? search}) async {
    String url = '$baseUrl/users?per_page=100'; // Request more data
    if (search != null && search.isNotEmpty) {
      url += '&search=$search';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      debugPrint('Get Users Response: ${response.body}');
      
      List dataList = [];
      // Matching standard Laravel API structure: { "success": true, "data": { "users": [...] } }
      if (decoded is Map && decoded.containsKey('data')) {
        var dataSection = decoded['data'];
        if (dataSection is Map && dataSection.containsKey('users')) {
          dataList = dataSection['users'];
        } else if (dataSection is List) {
          dataList = dataSection;
        }
      } else if (decoded is List) {
        dataList = decoded;
      }
      
      return dataList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      debugPrint('Get Users Error Body: ${response.body}');
      throw Exception('Gagal memuat user: ${response.statusCode}');
    }
  }

  // Create User
  Future<void> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: await _getHeaders(),
      body: json.encode(user.toJson()),
    );

    debugPrint('Create User Response: ${response.body}');
    if (response.statusCode != 201 && response.statusCode != 200) {
      if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        String message = errorData['message'] ?? 'Validation Error';
        if (errorData['data'] != null) {
          message = (errorData['data'] as Map).values.first[0];
        }
        throw Exception(message);
      }
      throw Exception('Gagal membuat user: ${response.statusCode}');
    }
  }

  // Update User
  Future<void> updateUser(int id, UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: await _getHeaders(),
      body: json.encode(user.toJson()),
    );

    debugPrint('Update User Response: ${response.body}');
    if (response.statusCode != 200) {
      if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        String message = errorData['message'] ?? 'Validation Error';
        if (errorData['data'] != null) {
          message = (errorData['data'] as Map).values.first[0];
        }
        throw Exception(message);
      }
      throw Exception('Gagal update user: ${response.statusCode}');
    }
  }

  // Delete User
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: await _getHeaders(),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  // --- AREA API ---
  Future<List<AreaModel>> getAreas({String? search, int perPage = 10}) async {
    String url = '$baseUrl/areas?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['areas'] != null) {
            dataList = data['areas'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => AreaModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat area');
  }

  Future<void> createArea(AreaModel area) async {
    final response = await http.post(
      Uri.parse('$baseUrl/areas'),
      headers: await _getHeaders(),
      body: json.encode(area.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updateArea(int id, AreaModel area) async {
    final response = await http.put(
      Uri.parse('$baseUrl/areas/$id'),
      headers: await _getHeaders(),
      body: json.encode(area.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteArea(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/areas/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus area');
  }

  // --- RUANG API ---
  Future<List<RuangModel>> getRuangs({String? search, int perPage = 10}) async {
    String url = '$baseUrl/ruangs?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['ruangs'] != null) {
            dataList = data['ruangs'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => RuangModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat ruang');
  }

  Future<void> createRuang(RuangModel ruang) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ruangs'),
      headers: await _getHeaders(),
      body: json.encode(ruang.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updateRuang(int id, RuangModel ruang) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ruangs/$id'),
      headers: await _getHeaders(),
      body: json.encode(ruang.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteRuang(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/ruangs/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus ruang');
  }

  // Common Error Handler
  void _handleError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      String message = errorData['message'] ?? 'Gagal memproses permintaan';
      if (errorData['error'] != null) {
        message = "$message: ${errorData['error']}";
      } else if (errorData['data'] != null && errorData['data'] is Map) {
        message = (errorData['data'] as Map).values.first[0].toString();
      }
      throw Exception(message);
    } catch (e) {
      if (e is Exception && !e.toString().contains('FormatException')) throw e;
      throw Exception('Gagal memproses permintaan: ${response.statusCode}');
    }
  }

  // --- KATEGORI SOP API ---
  Future<List<KategoriSopModel>> getKategoriSops({String? search, int perPage = 10}) async {
    String url = '$baseUrl/kategori-sops?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['kategori_sops'] != null) {
            dataList = data['kategori_sops'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => KategoriSopModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat kategori SOP');
  }

  Future<void> createKategoriSop(KategoriSopModel kategori) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kategori-sops'),
      headers: await _getHeaders(),
      body: json.encode(kategori.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updateKategoriSop(int id, KategoriSopModel kategori) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kategori-sops/$id'),
      headers: await _getHeaders(),
      body: json.encode(kategori.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteKategoriSop(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/kategori-sops/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus kategori SOP');
  }

  Future<Map<String, dynamic>> getSopsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/kategori-sops/$categoryId/sops'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Gagal memuat list SOP');
  }

  // --- SOP API ---
  Future<List<SopModel>> getSops({String? search, int perPage = 10}) async {
    String url = '$baseUrl/sops?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['sops'] != null) {
            dataList = data['sops'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => SopModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat SOP');
  }

  Future<void> createSop(SopModel sop) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sops'),
      headers: await _getHeaders(),
      body: json.encode(sop.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updateSop(int id, SopModel sop) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sops/$id'),
      headers: await _getHeaders(),
      body: json.encode(sop.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteSop(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/sops/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus SOP');
  }

  // ===============================
  // LANGKAH SOP API
  // ===============================

  Future<List<SopLangkahModel>> getLangkahSops({String? search, int? sopId, int perPage = 10}) async {
    String url = '$baseUrl/langkah-sops?per_page=$perPage&';
    if (search != null && search.isNotEmpty) url += 'search=$search&';
    if (sopId != null) url += 'sop_id=$sopId&';
    
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      debugPrint('Langkah API Response: ${response.body}');
      final jsonResponse = json.decode(response.body);
      final List data = jsonResponse['data']['langkahs'];
      return data.map((json) => SopLangkahModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat langkah SOP');
    }
  }

  Future<void> createLangkahSop(SopLangkahModel langkah) async {
    final response = await http.post(
      Uri.parse('$baseUrl/langkah-sops'),
      headers: await _getHeaders(),
      body: json.encode(langkah.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updateLangkahSop(int id, SopLangkahModel langkah) async {
    final response = await http.put(
      Uri.parse('$baseUrl/langkah-sops/$id'),
      headers: await _getHeaders(),
      body: json.encode(langkah.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteLangkahSop(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/langkah-sops/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus langkah SOP');
  }

  // ===============================
  // TUGAS SOP API
  // ===============================

  Future<List<TugasSopModel>> getTugasSops({String? search, int perPage = 10}) async {
    String url = '$baseUrl/tugas-sops?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['tugas'] != null) {
            dataList = data['tugas'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => TugasSopModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat tugas SOP');
  }

  Future<void> createTugasSop(Map<String, dynamic> tugasData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tugas-sops'),
      headers: await _getHeaders(),
      body: json.encode(tugasData),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteTugasSop(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tugas-sops/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus tugas SOP');
  }

  // ===============================
  // PELAKSANAAN SOP API
  // ===============================

  Future<List<SopPelaksanaanModel>> getPelaksanaanSops({String? search, int perPage = 10}) async {
    String url = '$baseUrl/pelaksanaan-sops?per_page=$perPage';
    if (search != null && search.isNotEmpty) url += '&search=$search';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList = [];
      if (decoded['data'] != null) {
        var data = decoded['data'];
        if (data is Map) {
          if (data['pelaksanaans'] != null) {
            dataList = data['pelaksanaans'];
          } else if (data['items'] != null) {
            dataList = data['items'];
          }
        } else if (data is List) {
          dataList = data;
        }
      }
      return dataList.map((e) => SopPelaksanaanModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat pelaksanaan SOP');
  }

  Future<void> createPelaksanaanSop(SopPelaksanaanModel pelaksanaan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pelaksanaan-sops'),
      headers: await _getHeaders(),
      body: json.encode(pelaksanaan.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> updatePelaksanaanSop(int id, SopPelaksanaanModel pelaksanaan) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pelaksanaan-sops/$id'),
      headers: await _getHeaders(),
      body: json.encode(pelaksanaan.toJson()),
    );
    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deletePelaksanaanSop(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pelaksanaan-sops/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) throw Exception('Gagal menghapus pelaksanaan SOP');
  }

  // ===============================
  // KARYAWAN API
  // ===============================

  Future<Map<String, dynamic>> getDashboardKaryawan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/karyawan/dashboard'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? {};
    }
    throw Exception('Gagal memuat dashboard karyawan');
  }

  Future<Map<String, dynamic>> getTugasKaryawan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/karyawan/tugas'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? {};
    }
    throw Exception('Gagal memuat tugas karyawan');
  }

  Future<void> mulaiTugasKaryawan(int langkahId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/karyawan/tugas/$langkahId/mulai'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      _handleError(response);
    }
  }

  Future<void> selesaiTugasKaryawan(int langkahId, {String? des, String? url}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/karyawan/tugas/$langkahId/selesai'),
      headers: await _getHeaders(),
      body: json.encode({
        if (des != null) 'des': des,
        if (url != null) 'url': url,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      _handleError(response);
    }
  }

  Future<Map<String, dynamic>> getLaporanKaryawan({String? startDate, String? endDate}) async {
    String url = '$baseUrl/karyawan/laporan';
    if (startDate != null && endDate != null) {
      url += '?start_date=$startDate&end_date=$endDate';
    }
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? {};
    }
    throw Exception('Gagal memuat laporan karyawan');
  }

  Future<Map<String, dynamic>> getProfilKaryawan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/karyawan/profile'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? {};
    }
    throw Exception('Gagal memuat profil karyawan');
  }

  Future<void> updateProfilKaryawan(String nama, String hp, {String? password, String? passwordConfirmation}) async {
    final body = {
      'nama': nama,
      'hp': hp,
    };
    
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
      body['password_confirmation'] = passwordConfirmation ?? '';
    }

    final response = await http.put(
      Uri.parse('$baseUrl/karyawan/profile'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      _handleError(response);
    }
  }
}


