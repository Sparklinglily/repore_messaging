// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:promptio/core/constants/app_colors.dart';
import 'package:promptio/core/constants/app_widget/app_widget.dart';
import 'package:promptio/core/constants/utils.dart';
import 'package:promptio/data/user_model.dart';
import 'package:promptio/presentation/groups/groups.dart';
import 'package:promptio/presentation/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:promptio/presentation/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;
  bool isLoading = false;

  Future<void> signUp() async {
    setState(() => isLoading = true);
    try {
      final user = await context
          .read<AuthProvider>()
          .createUserWithEmailAndPassword(emailController.text,
              passwordController.text, nameController.text,
              role: _selectedRole);
      if (user != null) {
        _showSnackBar(context, "SignUp Sucessful", false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      } else {
        _showSnackBar(context, "SignUp failed", true);
      }
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Repore',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  validator: (value) {},
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(width: 1, color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: AppColors.purple),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
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
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: AppColors.purple),
                        borderRadius: BorderRadius.circular(12)),
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
                              BorderSide(width: 1, color: AppColors.purple),
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
                DropdownButtonFormField<UserRole>(
                    dropdownColor: Colors.white,
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: UserRole.values.map((UserRole role) {
                      return DropdownMenuItem<UserRole>(
                        value: role,
                        child: Text(role.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (UserRole? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      }
                    }),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55),
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.purple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 24),
                AppTextSpan(
                  onTapped: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                  text1: "Already have an account? ",
                  text2: "Login",
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
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
