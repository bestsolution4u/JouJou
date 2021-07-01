import 'dart:typed_data';

import 'package:http/http.dart' as Http;
import 'package:joujou_lounge/constant/config.dart';
import 'dart:convert';

class HttpService {
  static Future<Http.Response> get(String uri) async {
    Map<String, String> headers = await getHeaders();
    return await Http.get("${Config.BASE_URL}/$uri", headers: headers);
  }

  static Future<Http.Response> post(String uri, Map<String, dynamic> params) async {
    Map<String, String> headers = await getHeaders();
    return await Http.post("${Config.BASE_URL}/$uri", headers: headers, body: getParamsJson(params));
  }

  static Future<Http.Response> delete(String uri, Map<String, dynamic> params) async {
    Map<String, String> headers = await getHeaders();
    return await Http.delete("${Config.BASE_URL}/$uri", headers: headers);
  }

  static Future<Map<String, String>> getHeaders() async {
    /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final userRepository = UserRepository(sharedPreferences);*/
    Map<String, String> headers = {};
    headers["Content-type"] = "application/json";
    //if (userRepository.getToken() != null) headers["Authorization"] = "Bearer " + userRepository.getToken();
    return headers;
  }

  static String getParamsJson(Map<String, dynamic> params) {
    return jsonEncode(params);
  }

  static Future<String> getImageString(String url) async {
    print("Fetch Image: $url");
    try {
      Http.Response response = await Http.get(url);
      return base64Encode(response.bodyBytes);
    } catch (err) {
      print("----- error catched ------");
      print(err.toString());
      return null;
    }
  }
}

