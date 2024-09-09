import 'package:auth_flutter/models/user_model.dart';
import 'package:auth_flutter/screens/admin_panel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_flutter/bloc/admin/admin_user_bloc.dart';
import 'package:auth_flutter/bloc/admin/admin_user_event.dart';
import 'package:auth_flutter/bloc/admin/admin_user_state.dart';
import 'package:auth_flutter/screens/admin_services_screen.dart';
import 'package:auth_flutter/screens/admin_update_details_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';
  late List<User> _filteredUsers;
  List<User> _allUsers = []; 
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminServicesScreen()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    BlocProvider.of<AdminUserBloc>(context).add(GetUsers());
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = BlocProvider.of<AdminUserBloc>(context).state;
    if (state is UserDataLoaded) {
      _allUsers = state.userdata;
      _filterUsers();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterUsers();
    });
  }

  void _filterUsers() {
    _filteredUsers = _allUsers.where((user) {
      return user.fullname.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Users'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search users',
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              borderRadius: BorderRadius.circular(8.0),
              backgroundColor: const Color.fromARGB(88, 167, 158, 158),
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminUserBloc, AdminUserState>(
              builder: (context, state) {
                if (state is UserDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserDataLoaded) {
                  _allUsers = state.userdata;
                  _filterUsers();
                  return ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: CircleAvatar(
                            backgroundImage: user.profilePicture != null
                                ? NetworkImage(user.profilePicture!)
                                : const AssetImage('assets/default_profile.png')
                                    as ImageProvider,
                            radius: 22,
                          ),
                          title: Text(
                            user.fullname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            user.email,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: () {
                                    if (user.id != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminUpdateDetailsScreen(
                                                  id: user.id!),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('User ID is missing!')),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.blue[700], // Text color
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDeleteDialog(context, user.id!);
                                },
                                icon: const Icon(Icons.delete),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Colors.red[700], // Text color
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                final bloc = BlocProvider.of<AdminUserBloc>(context);
                bloc.add(DeleteUser(userId));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
