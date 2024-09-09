import 'dart:convert';
import 'dart:io';
import 'package:auth_flutter/models/user_model.dart';
import 'package:auth_flutter/repositories/auth_repo.dart';
import 'package:auth_flutter/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository implements AuthRepo {
  static const String baseUrl = "http://10.0.2.2:3000/api/";

@override
  Future<User> userLogin(User user) async {
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:3000/api/auth/login'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final token = data['token'] as String?;
      if (token == null) {
        throw Exception('Access token is missing in the JSON response');
      }

      await SecureStorage.storeToken('access_token', token);

      final userData = data['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw Exception('User data is missing in the JSON response');
      }

      return User.fromJson(userData);
    } else {
      final errorMessage = response.body.isNotEmpty
          ? jsonDecode(response.body)['message'] ?? 'Failed to log in'
          : 'Failed to log in';

      throw Exception(errorMessage);
    }
  }

  @override
  Future<User> userRegistration(User user, File? profilePicture) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:3000/api/auth/registration'));

    request.fields['fullname'] = user.fullname;
    request.fields['username'] = user.username;
    request.fields['email'] = user.email;
    request.fields['contactNumber'] = user.contactNumber;
    request.fields['password'] = user.password;

    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', profilePicture.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      final registeredUser = User.fromJson(data);
      return registeredUser;
    } else {
      throw Exception('Failed to register: ${response.reasonPhrase}');
    }
  }
}
