import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class ApiProvider {
  final String baseUrl = "http://YOURDOMAIN/api";
  final storage = GetStorage();

  // Helper to get headers with token
  Map<String, String> _getHeaders() {
    String? token = storage.read('token');
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
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Create User
  Future<UserModel> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: _getHeaders(),
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Update User
  Future<UserModel> updateUser(int id, UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: _getHeaders(),
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete User
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: _getHeaders(),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
