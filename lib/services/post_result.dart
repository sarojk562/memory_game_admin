import 'dart:convert';

import 'package:flutter_memory_game/constants/routes/paths.dart';
import 'package:flutter_memory_game/constants/values/url.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<Map<String, dynamic>?> postResult(String time) async {
  const url = baseUrl + postResultEndpoint;
  final body = {
    "stub": {"timeTaken": time}
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body);
      return data;
    } else {
      return null;
    }
  } catch (error) {
    // Handle any network or other errors
    return null;
  }
}
