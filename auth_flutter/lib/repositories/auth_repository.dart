import 'dart:convert';
import 'dart:io';
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
    final Map<String, dynamic> data = jsonDecode(response.body);
    final userData = data['user'] as Map<String, dynamic>?;
    if (userData == null) {
      throw Exception('User data is missing in the JSON response');
    }
    return User.fromJson(userData);
  } else {
    throw Exception('Failed to log in');
  }
}



  @override
  Future<User> userRegistration(User user, File? profilePicture) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/registration'));

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
