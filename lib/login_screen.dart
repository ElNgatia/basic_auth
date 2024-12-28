import 'dart:developer';

import 'package:basic_auth/home_screen.dart';
import 'package:basic_auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text).then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }).onError((error, stackTrace) {
                  log('Error logging in: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging in: $error'),
                    ),
                  );
                });
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> login(String email, String password) async {
  // Replace with your actual Supabase URL and anonymous key
  const supabaseUrl = 'https://fqdadizukdpmrifhtscs.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZGFkaXp1a2RwbXJpZmh0c2NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNzcwMTYsImV4cCI6MjA1MDk1MzAxNn0.7l95HYXctBDdwRKE3qa0U7xznNDpKWXnri40Xl4rAhU';

  // Create an instance of SupabaseAuthService
  final authService = SupabaseAuthService(supabaseUrl, supabaseAnonKey);

  try {
    // Sign in with email and password
    final result = await authService.signInWithEmail(email, password);

    // Access the JWT and session
    final jwt = result['jwt'];

    final refreshToken = result['refresh_token'];

    // Save the JWT and refresh token in secure storage
    const storage = FlutterSecureStorage();
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'refresh_token', value: refreshToken);
  } catch (error) {
    log('Error signing in: $error');
    rethrow;
  }
}
