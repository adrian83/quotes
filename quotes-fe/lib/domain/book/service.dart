import 'dart:async';

import 'package:http/browser_client.dart';
import 'model.dart';

import '../common/service.dart';
import '../common/page.dart';

class BookService extends Service<Book> {

  static final String _host = "http://localhost:5050";

  BookService(BrowserClient http) : super(http);

  Future<BooksPage> list(String authorId, PageRequest request) async {
    //LOGGER.info("Get authors. Request params: $request");
    var path = "authors/$authorId/books";
    var url = listUrl(_host, path, this.pageRequestToUrlParams(request));
    var jsonPage = await getEntity(url);
    return new BooksPage.fromJson(jsonPage);
  }

}
