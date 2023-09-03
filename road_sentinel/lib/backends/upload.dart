import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

Future<Map<String, dynamic>> checkValidity() async {
  final apiUrl = "http://47.254.235.54:8000/uploads/valid";
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return json.decode('{"status": "Server not found..."}');
  }
}

Future<bool> uploadImage(
    XFile? imageFile, double? latitude, double? longitude) async {
  if (imageFile == null) return false;
  Uri uri = Uri.parse('http://47.254.235.54:8000/uploads');

  http.MultipartRequest request = http.MultipartRequest('POST', uri)
    ..fields['latitude'] = latitude.toString()
    ..fields['longitude'] = longitude.toString()
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path,
        contentType: MediaType('image', 'png')));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
