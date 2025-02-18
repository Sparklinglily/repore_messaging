// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:promptio/core/constants/app_colors.dart';
import 'package:promptio/core/constants/app_widget/app_widget.dart';
import 'package:promptio/core/constants/utils.dart';
import 'package:promptio/presentation/auth/sign_up.dart';
import 'package:promptio/presentation/groups/groups.dart';
import 'package:provider/provider.dart';
import 'package:promptio/presentation/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);
    try {
      await context.read<AuthProvider>().login(
            emailController.text,
            passwordController.text,
          );
      _showSnackBar(context, "Login Sucessful", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GroupsPage()),
      );
    } catch (e) {
      _showSnackBar(context, e.toString(), true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isObscured = false;
  void togglePasswordVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Repore',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Sign In',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 32),
              TextFormField(
                validator: (value) {
                  if (!isEmailValid(value!)) {
                    return "Please enter a valid email";
                  } else {
                    return null;
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value!.length < 8) {
                    return "Password must be at least 8 characters";
                  } else {
                    return null;
                  }
                },
                controller: passwordController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12)),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        togglePasswordVisibility();
                      },
                    )),
                obscureText: isObscured,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55),
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
              Spacer(),
              AppTextSpan(
                onTapped: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpPage()),
                    );
                  },
                text1: "Don't have an account? ",
                text2: "Sign Up",
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(
  BuildContext context,
  String message,
  bool isError,
) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError ? Colors.red : Colors.green,
          ),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
