import 'dart:convert';
import 'dart:developer';
import 'package:cutting_master/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

enum Result { success, error }

class Api {
  static String baseUrl = "176.124.208.61:2005";
  static String middle = "api/cuttingMaster";
  static String login = "api/login";
  static String order = "$middle/orders";
  static String model = "$middle/models";
  static String recipe = "$middle/recipes";
  static String showRecipe = "$middle/getrecipes";
  static String item = "$middle/items";
  static String material = "$middle/materials";
  static String unit = "$middle/units";
  static String color = "$middle/colors";
  static String razryad = "$middle/razryads";
  static String itemType = "$middle/itemtypes";
  static String department = "$middle/departments";
  static String user = "$middle/users";
  static String group = "$middle/groups";
  static String contragent = "$middle/contragents";
  static String sendToConstructor = "$middle/sendToConstructor";
  static String completedItem = "$middle/completedItem";
  static String specifications = "$middle/specifications";
  static String markAsCut = "$middle/markAsCut";
  static String cuts = "$middle/cuts";
  static String finishCutting = "$middle/finishCutting";
}

class HttpService {
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? param,
  }) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );
    Uri url = Uri.http(Api.baseUrl, endpoint, param);
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [GET]: ${response.body}\nCode: ${response.statusCode}\nURL: $url");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool isAuth = false,
  }) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(Api.baseUrl, isAuth ? "api/login" : endpoint);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [POST]: ${response.body}");

        return {
          'data': jsonDecode(response.body) ?? {},
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': jsonDecode("{'error': '$e'}") ?? {},
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(Api.baseUrl, endpoint);
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [PUT]: ${response.body}");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(Api.baseUrl, endpoint);
    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [PATCH]: ${response.body}");

        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(Api.baseUrl, endpoint);
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [DELETE]: ${response.body}");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> uploadWithImages(
    String endpoint, {
    required Map<String, dynamic> body,
    String method = 'post',
  }) async {
    print(body);
    try {
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      }..addAllIf(StorageService.read("token") != null, {"Authorization": "Bearer ${StorageService.read("token")}"});

      // API endpoint
      final url = Uri.http(
        Api.baseUrl,
        endpoint,
        {'_method': method},
      );

      var request = http.MultipartRequest("post", url);

      request.headers.addAll(headers);

      if (body['images'] != null) {
        for (var imagePath in body['images']) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            imagePath,
            filename: imagePath.split('/').last,
          ));
        }
      }

      body.remove('images');

      request.fields.addAll({
        "data": jsonEncode(body),
      });

      var res = await request.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {
          'data': jsonDecode(await res.stream.bytesToString()),
          'status': Result.success,
        };
      } else {
        log(await res.stream.bytesToString());
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'status': Result.error,
      };
    }
  }
}
