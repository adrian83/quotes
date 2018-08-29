import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/book/form.dart';
import '../../domain/book/model.dart';

class AddBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  AddBookHandler(this._bookService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var result = await parseForm(request, new BookFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var book = formToBook(result.form, idOrErr.value);
    var saved = _bookService.save(book);
    created(saved, request);
  }

  Book formToBook(BookForm form, String authorId) {
    return new Book(null, form.title, authorId);
  }
}
