import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './document.dart';
import './response.dart';
import './search.dart';

class ESStore<T extends ESDocument> {
  String _host, _index;
  int _port;

  ESStore(this._host, this._port, this._index);

  Future<IndexResult> index(T doc) async {
    var jsonBody = jsonEncode(doc);

    var path = "$_index/doc/${doc.getId()}";

    HttpClientRequest request = await HttpClient().post(_host, _port, path)
      ..headers.contentType = ContentType.json
      ..write(jsonBody);

    HttpClientResponse response = await request.close();
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));

    var t = new IndexResult.fromJson(jsonDecode(s));
    print(t);

    return t;
  }

  Future<UpdateResult> updateDocument(T doc) async {

    var jsonBody = jsonEncode(new UpdateDoc(doc));

    var path = "$_index/doc/${doc.getId()}/update";

    HttpClientRequest request = await HttpClient().put(_host, _port, path)
      ..headers.contentType = ContentType.json
      ..write(jsonBody);

    HttpClientResponse response = await request.close();
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));

    var t = new UpdateResult.fromJson(jsonDecode(s));
    print(t);

    return t;
  }

  Future<GetResult> get(String id) async {
    var path = "$_index/doc/$id";

    HttpClientRequest request = await HttpClient().get(_host, _port, path);

    HttpClientResponse response = await request.close();
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));

    var t = new GetResult.fromJson(jsonDecode(s));
    print(t);

    return t;
  }

  Future<DeleteResult> deleteDocument(String id) async {
    var path = "$_index/doc/$id";

    HttpClientRequest request = await HttpClient().delete(_host, _port, path);

    HttpClientResponse response = await request.close();
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));

    var t = new DeleteResult.fromJson(jsonDecode(s));
    print(t);

    return t;
  }

  Future<SearchResult> listDocuments(int from, int size) async {
    var req = new SearchRequest.all().withSize(size).withFrom(from);

    var jsonBody = jsonEncode(req);

    var path = "$_index/_search";

    HttpClientRequest request = await HttpClient().post(_host, _port, path)
      ..headers.contentType = ContentType.json
      ..write(jsonBody);

    HttpClientResponse response = await request.close();
    var s = await response.transform(utf8.decoder).join();
    print(jsonDecode(s));

    var t = new SearchResult.fromJson(jsonDecode(s));
    print(t);

    return t;
  }
}
