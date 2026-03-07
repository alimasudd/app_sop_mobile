import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maret/app/data/models/user_model.dart';

class ApiProvider {
  final String baseUrl = "https://cekdemo.com/ap/testmaret/public/api";

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

  // Get Users
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      debugPrint('Get Users Response: ${response.body}');
      
      List dataList = [];
      if (decoded is List) {
        dataList = decoded;
      } else if (decoded is Map) {
        // Handle {"data": {"users": [...]}}
        if (decoded.containsKey('data')) {
          var dataContent = decoded['data'];
          if (dataContent is List) {
            dataList = dataContent;
          } else if (dataContent is Map && dataContent.containsKey('users')) {
            dataList = dataContent['users'];
          } else if (dataContent is Map) {
             dataList = [dataContent];
          }
        } 
        // Handle {"users": [...]}
        else if (decoded.containsKey('users')) {
          dataList = decoded['users'];
        }
      }

      if (dataList.isEmpty && response.body.contains('"users":[')) {
         // Fallback manual search if logic above missed it
         throw Exception('Gagal memproses struktur JSON. Gunakan Map manual.');
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
        if (errorData['errors'] != null) {
          message = (errorData['errors'] as Map).values.first[0];
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
        if (errorData['errors'] != null) {
          message = (errorData['errors'] as Map).values.first[0];
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
}
