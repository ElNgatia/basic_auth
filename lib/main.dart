import 'package:basic_auth/home_screen.dart';
import 'package:basic_auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check if the user is logged in
  const secureStorage = FlutterSecureStorage();
  final String? jwt = await secureStorage.read(key: 'jwt');

  final bool isLoggedIn = jwt != null;
  if (isLoggedIn) {
    print('User is logged in');
  } else {
    print('User is not logged in');
  }
  runApp(MaterialApp(
    home: isLoggedIn ? const HomeScreen() : LoginScreen(),
  ));
}
