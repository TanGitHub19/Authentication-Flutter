import 'package:auth_flutter/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();
  @override
  List<Object> get props => [];
}

class UserDataLoading extends AdminUserState {}

class UserDataLoaded extends AdminUserState {
  final List<User> userdata;

  const UserDataLoaded(this.userdata);

  @override
  List<Object> get props => [userdata];
}

class UserDataLoadedById extends AdminUserState {
  final User user;

  const UserDataLoadedById(this.user);

  @override
  List<Object> get props => [];
}

class UserDataSuccess extends AdminUserState {
  final String message;

  const UserDataSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserDataError extends AdminUserState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object> get props => [message];
}


