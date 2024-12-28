import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService(String supabaseUrl, String supabaseAnonKey)
      : _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    log(response.session.toString());

    final session = response.session;
    final jwt = session?.accessToken;

    return {
      'jwt': jwt,
      'session': session,
      'refresh_token': session?.refreshToken,
    };
  }
}
