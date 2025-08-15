import 'dart:convert';

import 'package:customer_ui/model/user_model.dart';
import 'package:customer_ui/screen/home_page.dart';
import 'package:customer_ui/widget/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    // No need to call _login() here, only on button press
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final res = await http.get(
      Uri.parse(
        'https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/registers.json',
      ),
    );
    if (res.statusCode == 200 && res.body != 'null') {
      final Map<String, dynamic> data = json.decode(res.body);
      final List<UserModel> loaded = [];

      data.forEach((key, value) {
        loaded.add(UserModel.fromJson({"id": key, ...value}));
      });

      setState(() {
        users = loaded;
      });

      // Check credentials
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => UserModel(id: '', email: '', password: '', name: ''),
      );

      if (user.id.isNotEmpty) {
        // Login success, redirect to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } else {
      setState(() {
        users = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch users')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Use a placeholder if the image doesn't load
                  Image.asset(
                    'assets/lazada_logo.png',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.shopping_bag, size: 80),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Minimum 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },

                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                  // GestureDetector(
                  //   onTap: () {
                  //     // forgot password
                  //   },
                  //   child: const Text(
                  //     'Forgot Password?',
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
