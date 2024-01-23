import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkAPiServices {
  Future<dynamic> getApi(String Url) async {
    if (kDebugMode) print(Url);
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(Url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(response);
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = response.body;
        return responseJson;

      case 400:
        dynamic responseJson = jsonDecode(response.body);
        // if (responseJson["message"] == "cannot redeem before time") {
        Get.snackbar("message", "${responseJson["message"]}");
        // } else
        return responseJson;
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        Get.snackbar("message", "${responseJson["message"]}");

      case 403:
        dynamic responseJson = jsonDecode(response.body);
        Get.snackbar("message", "${responseJson["message"]}");

      default:
        throw SocketException(
            'Error accoured while communicating with server ${response.statusCode}');
    }
  }
}
