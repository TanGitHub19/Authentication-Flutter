import 'package:auth_flutter/models/user_model.dart';

abstract class ApiRepository {
  Future<List<User>> getUsers();
  Future<User> getUsersById(String id);
  Future<void> deleteUser(String id);
  Future<void> updateUser(String id, User user);
}
