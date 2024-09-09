import 'package:auth_flutter/bloc/booking/booking_bloc.dart';
import 'package:auth_flutter/screens/admin_services_screen.dart';
import 'package:auth_flutter/screens/admin_users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingBloc>(context).add(GetBooking());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminUsersScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminServicesScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is RequestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RequestError) {
            return Center(child: Text(state.error));
          } else if (state is RequestLoaded) {
            final bookings = state.bookings;
            return Column(
              children: [
                Container(
                  width: 370,
                  height: 180,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Admin Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "  Recent Activity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return ListTile(
                        title: Text(booking.user?.fullname ?? 'Unknown'),
                        subtitle: Text(booking.status),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
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
}
