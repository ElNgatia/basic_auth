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
  Future<List<dynamic>>? _carsFuture;

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch cars data using the access token
  Future<List<dynamic>> fetchCars() async {
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
      return response.data;
    } else {
      throw Exception('Failed to fetch cars: ${response.statusMessage}');
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
              setState(() {
                _carsFuture = fetchCars();
              });
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars available'));
          } else {
            final cars = snapshot.data!;
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  title: Text('${car['make']} ${car['model']}'),
                  subtitle: Text('Year: ${car['year']} - Color: ${car['color']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
