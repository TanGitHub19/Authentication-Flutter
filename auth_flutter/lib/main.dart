import 'package:auth_flutter/bloc/auth_bloc.dart';
import 'package:auth_flutter/repositories/auth_repository.dart';
import 'package:auth_flutter/screens/admin_panel_screen.dart';
import 'package:auth_flutter/screens/dashboard_screen.dart';
import 'package:auth_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
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
      initialRoute: '/',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/admin': (context) => const AdminPanelScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}
