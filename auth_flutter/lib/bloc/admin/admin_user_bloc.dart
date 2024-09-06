import 'package:auth_flutter/bloc/admin/admin_user_event.dart';
import 'package:auth_flutter/bloc/admin/admin_user_state.dart';
import 'package:auth_flutter/repositories/api_repository.dart';
import 'package:bloc/bloc.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final ApiRepository apiRepository;

  AdminUserBloc(this.apiRepository) : super(UserDataLoading()) {
    on<GetUsers>((event, emit) async {
      try{
        emit(UserDataLoading());
        final userdata = await apiRepository.getUsers();
        emit(UserDataLoaded(userdata));
      }catch (e){
        emit(UserDataError(e.toString()));
      }
    });

    on<DeleteUser>((event, emit) async {
      try{
        await apiRepository.deleteUser(event.id);
        add(GetUsers());
      } catch (e){
        emit(UserDataError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      try{
        await apiRepository.updateUser(event.id, event.user);
        add(GetUsers());
      } catch(e){
        emit(UserDataError(e.toString()));
      }
    });
  }
}
