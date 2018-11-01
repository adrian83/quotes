import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import './errors.dart';
import './page.dart';

class Service<T> {
  static final Logger logger = new Logger('Service');

  static final _headers = {'Content-Type': 'application/json'};

  final Client http;

  Service(this.http);

  Future<Map<String, dynamic>> createEntity(String url, T entity) => http
      .post(url, headers: _headers, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> updateEntity(String url, T entity) => http
      .put(url, headers: _headers, body: jsonEncode(entity))
      .then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> getEntity(String url) =>
      http.get(url).then((response) => _handleErrors(response));

  Future<Map<String, dynamic>> deleteEntity(String url) =>
      http.delete(url).then((response) => response.statusCode == 200
          ? new Map<String, dynamic>()
          : _handleErrors(response));

  Map<String, dynamic> _handleErrors(response) {
    if (response.statusCode == 404) {
      throw NotFoundError();
    }

    var json = jsonDecode(response.body);
    if (response.statusCode == 400) {
      logger.severe("json $json");
      var ve =  ValidationErrors.fromJson(json);
logger.severe("ve $ve");
      throw ve;
    } else if (response.statusCode == 500) {
      throw ServerError.fromJson(json);
    }
    logger.info("Http request: $json");
    return json;
  }

  String pageRequestToUrlParams(PageRequest request) {
    var params = new List<String>();
    params.add("limit=${request.limit}");
    params.add("offset=${request.offset}");
    return params.join("&");
  }
}
