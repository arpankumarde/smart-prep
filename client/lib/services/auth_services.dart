import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_prep/constants/constants.dart';
import 'package:smart_prep/models/user_model.dart';
import 'package:smart_prep/services/secure_storage_service.dart';

class AuthServices {
  final baseURL = Constants.baseURL;
  SecureStorageService storage = SecureStorageService();
  Future<Map<String, dynamic>> registerUser(String name, String username,
      String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/register'),
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        "role": role,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final user = UserModel.fromMap(decodedBody['user']);
      final token = decodedBody['token'];
      await storage.writeToken(token);
      return {
        'token': decodedBody['token'],
        'user': user,
      };
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String usernameOrEmail, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: jsonEncode({
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = UserModel.fromMap(decodedBody['user']);
      final token = decodedBody['token'];
      await storage.writeToken(token);
      return {
        'token': decodedBody['token'],
        'user': user,
      };
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<UserModel> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseURL/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<UserModel> getUserById(String token, int userId) async {
    final response = await http.get(
      Uri.parse('$baseURL/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromMap(decodedBody);
    } else {
      throw Exception(decodedBody);
    }
  }

  Future<Map<String, dynamic>> getAllUsers(String token,
      {int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.parse('$baseURL/users?page=$page&size=$size'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedBody;
    } else {
      throw Exception(decodedBody);
    }
  }
}
