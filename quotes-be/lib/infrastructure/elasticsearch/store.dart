import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'document.dart';
import 'response.dart'; 
import 'search.dart';
import 'exception.dart';

typedef Decode<T> = T Function(Map<String, dynamic> json);

class ESStore<T extends ESDocument> {
  HttpClient _client;
  String _host, _index, _protocol = "http", _type = "doc";
  int _port;

  String _statsUri() => "$_protocol://$_host:$_port/_stats";
  String _indexUri(String id) =>
      "$_protocol://$_host:$_port/$_index/$_type/$id";
  String _getUri(String id) => "$_protocol://$_host:$_port/$_index/$_type/$id";
  String _deleteUri(String id) =>
      "$_protocol://$_host:$_port/$_index/$_type/$id";
  String _searchUri() => "$_protocol://$_host:$_port/$_index/$_type/_search";
  String _updateUri(String id) =>
      "$_protocol://$_host:$_port/$_index/$_type/$id/_update";
  String _deleteByQueryUri() =>
      "$_protocol://$_host:$_port/$_index/$_type/_delete_by_query";

  static final Decode<IndexResult> _indexResDecoder =
      (Map<String, dynamic> json) => IndexResult.fromJson(json);
  static final Decode<UpdateResult> _updateResDecoder =
      (Map<String, dynamic> json) => UpdateResult.fromJson(json);
  static final Decode<GetResult> _getResDecoder =
      (Map<String, dynamic> json) => GetResult.fromJson(json);
  static final Decode<DeleteResult> _deleteResDecoder =
      (Map<String, dynamic> json) => DeleteResult.fromJson(json);
  static final Decode<SearchResult> _searchResDecoder =
      (Map<String, dynamic> json) => SearchResult.fromJson(json);
  static final Decode<DeleteByQueryResult> _delByQueryResDecoder =
      (Map<String, dynamic> json) => DeleteByQueryResult.fromJson(json);

  ESStore(this._client, this._host, this._port, this._index);

  Future<IndexResult> index(T doc) => _client
      .postUrl(Uri.parse(_indexUri(doc.eventId)))
      .then((req) => withBody(req, jsonEncode(doc)))
      .then((resp) => decode(resp, _indexResDecoder))
      .then((ir) => ir.result != created
          ? throw IndexingFailedException(
              "Cannot index ${doc.eventId} ${ir.result}")
          : ir);

  Future<UpdateResult> update(T doc) => _client
      .postUrl(Uri.parse(_updateUri(doc.eventId)))
      .then((req) => withBody(req, jsonEncode(UpdateDoc(doc))))
      .then((resp) => decode(resp, _updateResDecoder))
      .then(
          (ur) => ur.result != updated ? throw DocUpdateFailedException() : ur);

  Future<GetResult> get(String id) => _client
      .getUrl(Uri.parse(_getUri(id)))
      .then((req) => req.close())
      .then((resp) => decode(resp, _getResDecoder))
      .then((gr) => !gr.found ? throw DocFindFailedException() : gr);

  Future<DeleteResult> delete(String id) => _client
      .deleteUrl(Uri.parse(_deleteUri(id)))
      .then((req) => req.close())
      .then((resp) => decode(resp, _deleteResDecoder));

  Future<DeleteByQueryResult> deleteByQuery(Query query) => _client
      .postUrl(Uri.parse(_deleteByQueryUri()))
      .then((req) => withBody(req, jsonEncode(query)))
      .then((resp) => decode(resp, _delByQueryResDecoder));

  Future<SearchResult> list(SearchRequest searchRequest) => _client
      .postUrl(Uri.parse(_searchUri()))
      .then((req) => withBody(req, jsonEncode(searchRequest)))
      .then((resp) => decode(resp, _searchResDecoder));

  Future<bool> active() => _client
      .getUrl(Uri.parse(_statsUri()))
      .then((req) => req.close())
      .then((resp) => resp.statusCode == 200);

  Future<T> decode<T>(HttpClientResponse response, Decode<T> decode) => response
      .transform(utf8.decoder)
      .join()
      .then((content) => decode(jsonDecode(content)));

  Future<HttpClientResponse> withBody(HttpClientRequest request, String body) {
    request
      ..headers.contentType = ContentType.json
      ..write(body);
    return request.close();
  }
}
