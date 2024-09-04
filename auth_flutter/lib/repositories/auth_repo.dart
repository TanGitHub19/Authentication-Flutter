import 'package:auth_flutter/models/user_model.dart';

abstract class AuthRepo {
  Future<User> userRegistration(User user);
  Future<User> userLogin(User user);
}
