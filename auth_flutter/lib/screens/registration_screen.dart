import 'package:auth_flutter/bloc/auth_bloc.dart';
import 'package:auth_flutter/bloc/auth_event.dart';
import 'package:auth_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('assets/profile_image.png'),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Hello User!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Create your account!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.person_outline),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            hintText: 'Full Name'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.person_outlined),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            hintText: 'Username'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.email_outlined),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: TextField(
                        controller: contactNumberController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.phone_outlined),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            hintText: 'Contact Number'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 23.0, vertical: 12.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: _isPasswordVisible
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSucceed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is AuthFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthIsProcessing) {
                      return const CircularProgressIndicator();
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            final fullname = nameController.text;
                            final username = usernameController.text;
                            final email = emailController.text;
                            final contactNumber = contactNumberController.text;
                            final password = passwordController.text;
        
                            final user = User(
                              fullname: fullname,
                              username: username,
                              email: email,
                              contactNumber: contactNumber,
                              password: password,
                            );
        
                            BlocProvider.of<AuthBloc>(context)
                                .add(UserRegistration(user));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Center(
                              child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
