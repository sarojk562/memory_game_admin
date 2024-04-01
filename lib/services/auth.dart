import 'dart:convert';

import 'package:flutter_memory_game/constants/routes/paths.dart';
import 'package:flutter_memory_game/constants/values/url.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<Map<String, dynamic>?> loginUser(
    String username, String password) async {
  final url = '$baseUrl$getUserLevel/${Uri.encodeComponent(username)}';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
      // responseData = ResponseData.fromJson(data);
    } else {
      // Handle error based on status code or response message
      return null;
    }
  } catch (error) {
    // Handle any network or other errors
    return null;
  }
}
