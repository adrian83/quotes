import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import './errors.dart';
import './page.dart';

class Service<T> {
  static final Logger LOGGER = new Logger('Service');

  static final _headers = {'Content-Type': 'application/json'};

  final Client http;

  Service(this.http);

  Future<Map<String, dynamic>> createEntity(String url, T entity) async {
    var response =
        await http.post(url, headers: _headers, body: jsonEncode(entity));
    return _handleErrors(response);
  }

  Future<Map<String, dynamic>> updateEntity(String url, T entity) async {
    var response =
        await http.put(url, headers: _headers, body: jsonEncode(entity));
    return _handleErrors(response);
  }

  Future<Map<String, dynamic>> getEntity(String url) async {
    var response = await http.get(url);
    return _handleErrors(response);
  }

  Future<Map<String, dynamic>> deleteEntity(String url) async {
    var response = await http.delete(url);
    return response.statusCode == 200
        ? new Map<String, dynamic>()
        : _handleErrors(response);
  }

  Map<String, dynamic> _handleErrors(response) {
    var json = jsonDecode(response.body);
    if (response.statusCode == 400) {
      throw new ValidationErrors.fromJson(json);
    } else if (response.statusCode == 500) {
      throw new ServerError.fromJson(json);
    }
    return json;
  }

  String listUrl(String api, String url, String params) => "$api/$url?$params";
  String getUrl(String api, String url, String id) => "$api/$url/$id";
  String createUrl(String api, String url) => "$api/$url";
  String updateUrl(String api, String url, String id) => getUrl(api, url, id);
  String deleteUrl(String api, String url, String id) => getUrl(api, url, id);

  String pageRequestToUrlParams(PageRequest request) {
    var params = new List<String>();
    params.add("limit=${request.limit}");
    params.add("offset=${request.offset}");
    return params.join("&");
  }
}
