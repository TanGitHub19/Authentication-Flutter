import 'package:auth_flutter/bloc/admin/admin_user_bloc.dart';
import 'package:auth_flutter/bloc/admin/admin_user_event.dart';
import 'package:auth_flutter/bloc/admin/admin_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  void showDeleteDialog(
      BuildContext context, String? userName, String? userId) {
    if (userId == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text(
              'Are you sure you want to delete ${userName ?? 'Unnamed User'}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                BlocProvider.of<AdminUserBloc>(context).add(DeleteUser(userId));
                Navigator.of(context)
                    .pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: BlocBuilder<AdminUserBloc, AdminUserState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserDataLoaded) {
            return ListView.builder(
              itemCount: state.userdata.length,
              itemBuilder: (context, index) {
                final user = state.userdata[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profilePicture != null
                        ? NetworkImage(user.profilePicture!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                    radius: 20,
                  ),
                  title: Text(user.fullname),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDeleteDialog(context, user.fullname, user.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is UserDataError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
