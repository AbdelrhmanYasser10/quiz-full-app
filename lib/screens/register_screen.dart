import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:new_quiz_full_app/utlis/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black87,
                        Colors.black54,
                        Colors.black45,
                        Colors.black38,
                        Colors.black26,
                        Colors.black12,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register',
                              style: GoogleFonts.manrope(
                                textStyle: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              'Continue to join our community',
                              style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade200),
                              ),
                            ),
                            verticalSpace(heightSpace: 40.0),
                            MyTextFormField(
                              controller: _usernameController,
                              hintText: "Username",
                              icon: Icons.person,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name must not be empty";
                                }
                                return null;
                              },
                            ),
                            verticalSpace(heightSpace: 20.0),
                            MyTextFormField(
                              controller: _emailController,
                              hintText: "Email",
                              icon: Icons.email_outlined,
                              enabled: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name must not be empty";
                                }
                                return null;
                              },
                            ),
                            verticalSpace(heightSpace: 20.0),
                            MyTextFormField(
                              controller: _passwordController,
                              hintText: "Password",
                              icon: Icons.lock_outline,
                              enabled: false,
                              isPassword: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name must not be empty";
                                }
                                return null;
                              },
                            ),
                            verticalSpace(heightSpace: 20.0),
                            MyTextFormField(
                              controller: _confPasswordController,
                              hintText: "Password Confirmation",
                              icon: Icons.lock_outline,
                              enabled: false,
                              isPassword: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name must not be empty";
                                }
                                if (value != _passwordController.text) {
                                  return "Password confirmation doesn't match the password";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: state is RegisterLoading
                            ? const Center(
                                child: LinearProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.register(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      username: _usernameController.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Register',
                                    style: GoogleFonts.manrope(
                                      textStyle: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget verticalSpace({required double heightSpace}) {
    return SizedBox(
      height: heightSpace,
    );
  }
}
