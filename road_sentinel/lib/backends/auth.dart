import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getSessionToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('sessionCookie');
}

bool isSessionTokenValid(String? sessionToken) {
  return sessionToken != null && sessionToken.isNotEmpty;
}

Future<bool> checkSessionToken() async {
  String? session = await getSessionToken();
  return isSessionTokenValid(session);
}

Future<Map<String, dynamic>> authUser(String email, String password) async {
  final apiUrl = "http://47.254.235.54:8000/app/login";
  final headers = {'Content-Type': 'application/json'};
  final body =
      jsonEncode({'email': email.trim().toLowerCase(), 'password': password});

  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: body);

  if (response.statusCode == 200) {
    final session_cookie = response.headers['set-cookie'];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionCookie', session_cookie!);
    return json.decode(response.body);
  } else {
    return json.decode('{"status": "Server not found..."}');
  }
}

Future<void> logoutUser() async {
  final apiUrl = "http://47.254.235.54:8000/app/logout";
  final prefs = await SharedPreferences.getInstance();
  final sessionCookie = prefs.getString('sessionCookie');
  if (sessionCookie != null) {
    final response =
        await http.get(Uri.parse(apiUrl), headers: {'Cookie': sessionCookie});
    if (response.statusCode == 200) {
      prefs.remove('sessionCookie');
    } else {}
  }
}
