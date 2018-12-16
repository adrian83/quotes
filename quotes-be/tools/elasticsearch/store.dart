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

  Future<IndexResult> index(T doc) {
    return _client
        .postUrl(Uri.parse(_indexUri(doc.eventId)))
        .then((httpCliReq) => withBody(httpCliReq, jsonEncode(doc)))
        .then((httpCliResp) => decode(httpCliResp, _indexResDecoder))
        .then((ir) {
      if (ir.result != created) throw SaveFailedException();
      return ir;
    });
  }

  Future<UpdateResult> update(T doc) => _client
          .postUrl(Uri.parse(_updateUri(doc.eventId)))
          .then(
              (httpCliReq) => withBody(httpCliReq, jsonEncode(UpdateDoc(doc))))
          .then((httpCliResp) => decode(httpCliResp, _updateResDecoder))
          .then((ur) {
        if (ur.result != updated) throw UpdateFailedException();
        return ur;
      });

  Future<GetResult> get(String id) => _client
          .getUrl(Uri.parse(_getUri(id)))
          .then((HttpClientRequest req) => req.close())
          .then((HttpClientResponse resp) => decode(resp, _getResDecoder))
          .then((gr) {
        if (!gr.found) throw FindFailedException();
        return gr;
      });

  Future<DeleteResult> delete(String id) => _client
      .deleteUrl(Uri.parse(_deleteUri(id)))
      .then((HttpClientRequest req) => req.close())
      .then((HttpClientResponse resp) => decode(resp, _deleteResDecoder));

  Future<DeleteByQueryResult> deleteByQuery(Query query) => _client
      .postUrl(Uri.parse(_deleteByQueryUri()))
      .then((httpCliReq) => withBody(httpCliReq, jsonEncode(query)))
      .then((HttpClientResponse resp) => decode(resp, _delByQueryResDecoder));

  Future<SearchResult> list(SearchRequest searchRequest) =>
      _client.postUrl(Uri.parse(_searchUri())).then((HttpClientRequest req) {
        print("List query ${jsonEncode(searchRequest)}");
        return withBody(req, jsonEncode(searchRequest));
      }).then((HttpClientResponse resp) => decode(resp, _searchResDecoder));

  Future<T> decode<T>(HttpClientResponse response, Decode<T> decode) =>
      response.transform(utf8.decoder).join().then((content) {
        print(content);
        return content;
      }).then((content) => decode(jsonDecode(content)));

  Future<HttpClientResponse> withBody(HttpClientRequest request, String body) {
    request
      ..headers.contentType = ContentType.json
      ..write(body);
    return request.close();
  }
}