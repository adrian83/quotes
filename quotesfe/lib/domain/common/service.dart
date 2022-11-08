import 'dart:async';
import 'dart:convert';

import 'dart:developer' as developer;
import 'package:http/http.dart';

import 'errors.dart';
import 'page.dart';

class Service<T> {
  static final _headers = {'Content-Type': 'application/json'};

  static final _corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    "Access-Control-Allow-Headers": "*"
  };

  static final _allHeaders = {
    ..._headers,
    ..._corsHeaders,
  };

  final Client http;

  Service(this.http);

  Future<Map<String, dynamic>> createEntity(String url, T entity) => http
      .post(Uri.parse(url), headers: _allHeaders, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> updateEntity(String url, T entity) => http
      .put(Uri.parse(url), headers: _allHeaders, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> getEntity(String url) => http
      .get(Uri.parse(url), headers: _corsHeaders)
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> deleteEntity(String url) =>
      http.delete(Uri.parse(url), headers: _corsHeaders).then((response) =>
          response.statusCode == 200 ? {} : _handleErrors(response));

  Map<String, dynamic> _handleErrors(response) {
    developer.log("statusCode ${response.statusCode}");
    if (response.statusCode == 404) {
      throw NotFoundError();
    }

    if (response.statusCode == 400) {
      var json = jsonDecode(response.body);
      developer.log("json $json");
      var ve = ValidationErrors.fromJson(json);
      //logger.severe("ve $ve");
      throw ve;
    } else if (response.statusCode == 500) {
      throw Exception(jsonDecode(response.body));
    }
    //logger.info("Http request: $json");
    return jsonDecode(response.body);
  }

  String pageRequestToUrlParams(PageRequest request) =>
      ["limit=${request.limit}", "offset=${request.offset}"].join("&");

  String appendUrlParam(String params, String kay, String value) {
    if (value.isEmpty) {
      return params;
    }

    var pair = "$kay=$value";
    if (params.isEmpty) {
      return pair;
    }

    return "$params&$pair";
  }
}
