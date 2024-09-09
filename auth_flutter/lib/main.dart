import 'package:auth_flutter/bloc/admin/admin_user_bloc.dart';
import 'package:auth_flutter/bloc/admin/admin_user_event.dart';
import 'package:auth_flutter/bloc/auth_bloc.dart';
import 'package:auth_flutter/bloc/booking/booking_bloc.dart';
import 'package:auth_flutter/repositories/api_repository_impl.dart';
import 'package:auth_flutter/repositories/auth_repository.dart';
import 'package:auth_flutter/repositories/booking_repo_impl.dart';
import 'package:auth_flutter/screens/admin_panel_screen.dart';
import 'package:auth_flutter/screens/admin_services_screen.dart';
import 'package:auth_flutter/screens/admin_users_screen.dart';
import 'package:auth_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (context) =>
              AdminUserBloc(ApiRepositoryImpl())..add(GetUsers()),
        ),
        BlocProvider(
          create: (context) => BookingBloc(BookingRepoImpl()),
          child: const AdminServicesScreen(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/dashboard": (context) => const AdminPanelScreen(),
        "/users": (context) => const AdminUsersScreen(),
        "/services": (context) => const AdminServicesScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}
