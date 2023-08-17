import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> authUser(String email, String password) async {
  final apiUrl = "https://road-sentinel.onrender.com/app/login";
  final headers = {'Content-Type': 'application/json'};
  final body =
      jsonEncode({'email': email.trim().toLowerCase(), 'password': "admin"});

  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: body);

  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body);
  } else {
    return json.decode('{"status": Server not found..."}');
  }
}
