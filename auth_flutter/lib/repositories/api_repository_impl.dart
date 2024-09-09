import 'dart:convert';
import 'package:auth_flutter/models/user_model.dart';
import 'package:auth_flutter/repositories/api_repository.dart';
import 'package:auth_flutter/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiRepositoryImpl extends ApiRepository {
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  @override
  Future<List<User>> getUsers() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2:3000/api/users/"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final response =
        await http.delete(Uri.parse('http://10.0.2.2:3000/api/users/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student: ${response.reasonPhrase}');
    }
  }

  @override
  Future<void> updateUser(String id, User user) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/api/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.reasonPhrase}');
    }
  }

  @override
  Future<User> getUsersById(String id) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/users/$id'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user with ID: $id');
    }
  }

}
