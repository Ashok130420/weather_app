import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../utils/constants.dart';
import 'app_exception.dart';
import 'cache_service.dart';
import 'package:http/http.dart' as http;

class RestHelper {
  static final Map<String, String> _cacheMap = {};

  RestHelper._();

  static Future<Map<String, dynamic>> deleteRequest(String url, BuildContext context,
      {Map<String, String>? body, bool authorization = false}) async {
    try {

      var headers = {
        "Content-Type": "application/json",
      };
      if (authorization) {
        var token = await CacheService.readCache(key: Constants.token);
        headers["Authorization"] = "bearer $token";
      }

      var response = await delete(Uri.parse(url), headers: headers, body: body == null ? null : jsonEncode(body));

      log("Response for $url : ${response.body}", time: DateTime.now(), name: "REST");

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } catch (e) {
      throw AppException(900, "Unexpected error occurred", e.toString());
    }
  }

  // static Future<Map<String, dynamic>> getRequest(String url,
  //     { bool useCache = false, bool authorization = false}) async {
  //   try {
  //     var headers = {
  //       "Content-Type": "application/json",
  //     };
  //     if (authorization) {
  //       var token = await CacheService.readCache(key: Constants.token);
  //       headers["Authorization"] = "bearer $token";
  //     }
  //
  //     if (useCache && _cacheMap.containsKey(url)) {
  //       return jsonDecode(_cacheMap[url]!);
  //     }
  //
  //     var response = await get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 20), onTimeout: () {
  //       throw FetchDataException("Request timeout");
  //     });
  //
  //     log("Response for $url : ${response.body}", name: "REST");
  //
  //     if (useCache) _cacheMap[url] = response.body;
  //     return _processResponse(response);
  //   } on SocketException {
  //     throw FetchDataException("No Internet connection");
  //   } catch (e) {
  //     throw AppException(900, "Unexpected error occurred", e.toString());
  //   }
  // }

  static Future<dynamic> getRequest(String url,
      {bool useCache = false, bool authorization = false}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
      };
      if (authorization) {
        var token = await CacheService.readCache(key: Constants.token);
        headers["Authorization"] = "bearer $token";
      }

      if (useCache && _cacheMap.containsKey(url)) {
        return jsonDecode(_cacheMap[url]!);
      }

      var response = await get(Uri.parse(url), headers: headers).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw FetchDataException("Request timeout");
        },
      );

      log("Response for $url : ${response.body}", name: "REST");

      if (useCache) _cacheMap[url] = response.body;
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } catch (e) {
      throw AppException(900, "Unexpected error occurred", e.toString());
    }
  }


  static Future<Map<String, dynamic>> postRequest(String url, Map<String, dynamic> body, BuildContext context,
      { bool authorization = false}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
      };
      if (authorization) {
        var token = await CacheService.readCache(key: Constants.token);
        headers["Authorization"] = "bearer $token";
      }

      var response =
          await post(Uri.parse(url), headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20), onTimeout: () {
        throw FetchDataException("Request timeout");
      });

      log("Response for $url : ${response.body}", time: DateTime.now(), name: "REST");

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } catch (e) {
      throw AppException(900, "Unexpected error occurred", e.toString());
    }
  }

  static Future<Map<String, dynamic>> putRequest(String url, Map<String, dynamic> body, BuildContext context,
      { bool authorization = false}) async {
    try {
      var headers = {
        "Content-Type": "application/json",
      };
      if (authorization) {
        var token = await CacheService.readCache(key: Constants.token);
        headers["Authorization"] = "bearer $token";
      }

      var response = await put(Uri.parse(url), headers: headers, body: jsonEncode(body));

      log("Response for $url : ${response.body}", time: DateTime.now(), name: "REST");

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } catch (e) {
      throw AppException(900, "Unexpected error occurred", e.toString());
    }
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw BadRequestException(responseBody["message"]);
      case 401:
      case 403:
        throw UnauthorisedException(responseBody["message"]);
      case 422:
        throw InvalidInputException(responseBody["message"]);
      default:
        throw FetchDataException("Error occurred with status code: ${response.statusCode}");
    }
  }
}
