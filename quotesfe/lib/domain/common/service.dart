import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'package:quotesfe/domain/common/errors.dart';
import 'package:quotesfe/domain/common/page.dart';

const paramSearchPhrase = "searchPhrase";

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

  final Client _httpClient;

  Service(this._httpClient);

  Future<Map<String, dynamic>> createEntity(String url, T entity) => _httpClient
      .post(Uri.parse(url), headers: _allHeaders, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> updateEntity(String url, T entity) => _httpClient
      .put(Uri.parse(url), headers: _allHeaders, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> getEntity(String url) => _httpClient
      .get(Uri.parse(url), headers: _corsHeaders)
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> deleteEntity(String url) => _httpClient
      .delete(Uri.parse(url), headers: _corsHeaders)
      .then((response) =>
          response.statusCode == 200 ? {} : _handleErrors(response));

  Map<String, dynamic> _handleErrors(response) {
    if (response.statusCode == 404) {
      throw NotFoundError();
    } else if (response.statusCode == 400) {
      var json = jsonDecode(response.body);
      throw ValidationErrors.fromJson(json);
    } else if (response.statusCode == 500) {
      throw Exception(jsonDecode(response.body));
    }

    return jsonDecode(response.body);
  }

  String pageRequestToUrlParams(PageRequest request) => [
        "$fieldPageInfoLimit=${request.limit}",
        "$fieldPageInfoOffset=${request.offset}"
      ].join("&");

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
