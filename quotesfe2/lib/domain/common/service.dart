import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
//import 'package:logging/logging.dart';

import 'errors.dart';
import 'page.dart';

class Service<T> {
  // static final Logger logger = Logger('Service');

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
    if (response.statusCode == 404) {
      throw NotFoundError();
    }

    var json = jsonDecode(response.body);
    if (response.statusCode == 400) {
      //logger.severe("json $json");
      var ve = ValidationErrors.fromJson(json);
      //logger.severe("ve $ve");
      throw ve;
    } else if (response.statusCode == 500) {
      throw Exception(json);
    }
    //logger.info("Http request: $json");
    return json;
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
