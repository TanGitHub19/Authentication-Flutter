import 'package:auth_flutter/bloc/auth_event.dart';
import 'package:auth_flutter/bloc/auth_state.dart';
import 'package:auth_flutter/repositories/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:auth_flutter/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(AuthInitial()) {
    on<UserRegistration>((event, emit) async {
      try {
        await _authRepo.userRegistration(event.user, event.profilePicture);
        emit(const AuthSucceed('Registration Success'));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<UserLogin>((event, emit) async {
      try {
        final User user = await _authRepo.userLogin(event.user);
        emit(AuthSuccessWithRole(user.role));
        emit(const AuthSucceed('Login Success'));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
