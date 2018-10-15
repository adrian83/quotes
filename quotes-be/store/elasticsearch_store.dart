import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './document.dart';
import './response.dart';
import './search.dart';
import '../domain/common/exception.dart';

typedef Decode<T> = T Function(Map<String, dynamic> json);

class ESStore<T extends ESDocument> {
  HttpClient _client;
  String _host, _index, _protocol = "http";
  int _port;

  String _indexUri(String id) => "$_protocol://$_host:$_port/$_index/doc/$id";
  String _getUri(String id) => "$_protocol://$_host:$_port/$_index/doc/$id";
  String _deleteUri(String id) => "$_protocol://$_host:$_port/$_index/doc/$id";
  String _searchUri() => "$_protocol://$_host:$_port/$_index/_search";
  String _updateUri(String id) => "$_protocol://$_host:$_port/$_index/doc/$id/update";

  static final Decode<IndexResult> _indexResDecoder =
      (Map<String, dynamic> json) => new IndexResult.fromJson(json);
  static final Decode<UpdateResult> _updateResDecoder =
      (Map<String, dynamic> json) => new UpdateResult.fromJson(json);
  static final Decode<GetResult> _getResDecoder =
      (Map<String, dynamic> json) => new GetResult.fromJson(json);
  static final Decode<DeleteResult> _deleteResDecoder =
      (Map<String, dynamic> json) => new DeleteResult.fromJson(json);
  static final Decode<SearchResult> _searchResDecoder =
      (Map<String, dynamic> json) => new SearchResult.fromJson(json);

  ESStore(this._client, this._host, this._port, this._index);

  Future<IndexResult> index(T doc) async {
    return _client
        .postUrl(Uri.parse(_indexUri(doc.getId())))
        .then((HttpClientRequest req) async =>
            await withBody(req, jsonEncode(doc)))
        .then((HttpClientResponse resp) async =>
            await decode(resp, _indexResDecoder).then((ir) {
              if (ir.result != created) throw SaveFailedException();
              return ir;
            }));
  }

  Future<UpdateResult> update(T doc) async {
    return _client
        .putUrl(Uri.parse(_updateUri(doc.getId())))
        .then((HttpClientRequest req) async =>
            await withBody(req, jsonEncode(doc)))
        .then((HttpClientResponse resp) async =>
            await decode(resp, _updateResDecoder).then((ur){
              if (ur.result != updated) throw UpdateFailedException();
              return ur;
            }));
  }

  Future<GetResult> get(String id) async {
    return _client
        .getUrl(Uri.parse(_getUri(id)))
        .then((HttpClientRequest req) async => await req.close())
        .then((HttpClientResponse resp) async =>
            await decode(resp, _getResDecoder)).then((gr){
              if(!gr.found) throw FindFailedException();
              return gr;
            });
  }

  Future<DeleteResult> delete(String id) async {
    return _client
        .deleteUrl(Uri.parse(_deleteUri(id)))
        .then((HttpClientRequest req) async => await req.close())
        .then((HttpClientResponse resp) async =>
            await decode(resp, _deleteResDecoder));
  }

  Future<SearchResult> list(SearchRequest searchRequest) async {
    return _client
        .postUrl(Uri.parse(_searchUri()))
        .then((HttpClientRequest req) async =>
            await withBody(req, jsonEncode(searchRequest)))
        .then((HttpClientResponse resp) async =>
            await decode(resp, _searchResDecoder));
  }

  Future<T> decode<T>(HttpClientResponse response, Decode<T> decode) async {
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));
    return decode(jsonDecode(s));
  }

  Future<HttpClientResponse> withBody(
      HttpClientRequest request, String body) async {
    request
      ..headers.contentType = ContentType.json
      ..write(body);
    return request.close();
  }
}
