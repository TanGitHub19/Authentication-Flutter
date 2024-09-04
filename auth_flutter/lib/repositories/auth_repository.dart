import 'dart:convert';
import 'package:auth_flutter/models/user_model.dart';
import 'package:auth_flutter/repositories/auth_repo.dart';
import 'package:http/http.dart' as http;


class AuthRepository implements AuthRepo {
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  @override
  Future<User> userLogin(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      return user;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<User> userRegistration(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registration'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final registeredUser = User.fromJson(data);
      return registeredUser;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
