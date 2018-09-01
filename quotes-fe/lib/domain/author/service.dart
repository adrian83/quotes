import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'model.dart';
//import 'package:angular/angular.dart';


//@Injectable()
class AuthorService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _authorsUrl = 'http://localhost:5050/authors';
  final BrowserClient _http;

  AuthorService(this._http);

  Future<List<Author>> getAll() async {
    try {
      final response = await _http.get(_authorsUrl);
      final authors = (_extractData(response) as List)
          .map((value) => Author.fromJson(value))
          .toList();
      print(authors);
      return authors;
    } catch (e) {
      throw _handleError(e);
    }
  }

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

dynamic _extractData(Response resp) => json.decode(resp.body);

}
