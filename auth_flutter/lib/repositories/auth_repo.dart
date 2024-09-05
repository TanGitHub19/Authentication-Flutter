import 'dart:io';

import 'package:auth_flutter/models/user_model.dart';

abstract class AuthRepo {
  Future<User> userRegistration(User user, File? profilePicture);
  Future<User> userLogin(User user);
}
