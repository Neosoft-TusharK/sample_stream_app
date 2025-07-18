import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  Future<String> login([int userId = 1]) async {
    final resp = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body)['token'];
    }
    throw Exception('Login failed');
  }
}
