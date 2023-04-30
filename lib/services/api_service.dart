import 'package:frontend/shared/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = Globals.baseApiUrl;

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
