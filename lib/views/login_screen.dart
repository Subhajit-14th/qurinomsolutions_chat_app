import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/auth/auth_bloc.dart';
import '../viewmodel/auth/auth_event.dart';
import '../viewmodel/auth/auth_state.dart';
import 'chat_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController =
      TextEditingController(text: "swaroop.vass@gmail.com");
  final _passwordController = TextEditingController(text: "@Tyrion99");
  String _role = "vendor"; // or "customer"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            debugPrint("My user details: ${state.user.user.id}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChatListScreen(user: state.user.user),
              ),
            );
          } else if (state is AuthFailure) {
            debugPrint("Login process error: ${state.message}");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _role,
                  items: const [
                    DropdownMenuItem(
                        value: "customer", child: Text("Customer")),
                    DropdownMenuItem(value: "vendor", child: Text("Vendor")),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _role = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                            LoginRequested(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _role,
                            ),
                          );
                        },
                        child: const Text("Login"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
