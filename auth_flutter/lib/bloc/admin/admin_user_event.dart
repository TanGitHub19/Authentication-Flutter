import 'package:auth_flutter/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();
  @override
  List<Object> get props => [];
}

class GetUsers extends AdminUserEvent {}

class GetUsersById extends AdminUserEvent {
  final String id;

  const GetUsersById(this.id);

  @override
  List<Object> get props => [];
  }


class DeleteUser extends AdminUserEvent {
  final String id;

  const DeleteUser(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateUser extends AdminUserEvent {
  final String id;
  final User user;

  const UpdateUser(this.id, this.user);

  @override
  List<Object> get props => [id, user];
}

class AdminReset extends AdminUserEvent{}

