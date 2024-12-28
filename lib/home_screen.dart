import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> cars = [];
  String errorMessage = '';

  // Function to fetch cars data using the access token
  Future<void> fetchCars() async {
    const String supabaseUrl = 'https://fqdadizukdpmrifhtscs.supabase.co';
    final String? accessToken = await const FlutterSecureStorage().read(key: 'jwt');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    log(accessToken);

    final response = await Dio().get(
      '$supabaseUrl/rest/v1/cars',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'apiKey':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZGFkaXp1a2RwbXJpZmh0c2NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNzcwMTYsImV4cCI6MjA1MDk1MzAxNn0.7l95HYXctBDdwRKE3qa0U7xznNDpKWXnri40Xl4rAhU',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      log(response.data);
      setState(() {
        cars = response.data;
        errorMessage = '';
      });
    } else {
      setState(() {
        errorMessage = 'Failed to fetch cars ${response.statusMessage}';
      });

      throw Exception('Failed to fetch cars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                fetchCars().onError((error, stackTrace) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error fetching cars: $error'),
                      ),
                    );
                  }
                });
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  title: Text('${car['make']} ${car['model']}'),
                  subtitle: Text('Year: ${car['year']} - Color: ${car['color']}'),
                );
              },
            ),
    );
  }
}
