import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinomsolutions/utils/app_color.dart';
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBodyColor,
      // appBar: AppBar(title: const Text("Login")),
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
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.componantColor1DPElevation,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page heading
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: AppColor.appTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dropdown value
                  DropdownButton<String>(
                    value: _role,
                    dropdownColor: AppColor.componantColor4DPElevation,
                    style: TextStyle(
                      color: AppColor.appTextColor,
                    ),
                    underline: SizedBox(),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: "customer",
                          child: Text(
                            "Customer",
                            style: TextStyle(color: AppColor.appTextColor),
                          )),
                      DropdownMenuItem(
                          value: "vendor",
                          child: Text(
                            "Vendor",
                            style: TextStyle(color: AppColor.appTextColor),
                          )),
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

                  // Email TextField
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.componantColor4DPElevation,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: AppColor.appTextColor,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: AppColor.appTextColor,
                        ),
                        fillColor: AppColor.componantColor4DPElevation,
                        contentPadding: EdgeInsets.only(left: 6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Password TextField
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.componantColor4DPElevation,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: TextStyle(
                        color: AppColor.appTextColor,
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: AppColor.appTextColor,
                        ),
                        border: InputBorder.none,
                        fillColor: AppColor.componantColor4DPElevation,
                        contentPadding: EdgeInsets.only(left: 6),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.appTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  state is AuthLoading
                      ? Center(
                          child: const CircularProgressIndicator(
                            color: AppColor.appTextColor,
                            backgroundColor: AppColor.screenBodyColor,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginRequested(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _role,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColor.componantColor4DPElevation,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: AppColor.appTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
