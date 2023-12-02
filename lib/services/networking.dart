import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  final String baseUrl;

  NetworkHelper(this.baseUrl);

  Future<void> getData() async {
    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
