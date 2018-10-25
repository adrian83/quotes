import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/book/form.dart';
import '../../domain/common/form.dart';
import '../../domain/book/model.dart';

class UpdateBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  UpdateBookHandler(this._bookService) : super(_URL, "PUT") {}

  void execute(HttpRequest request) async {
    var parsedForm = await parseForm(request, new BookFormParser());
    if (parsedForm.hasErrors()) {
      badRequest(parsedForm.errors, request);
      return;
    }

    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");
    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var quote =
        formToBook(parsedForm.form, authorIdOrErr.value, bookIdOrErr.value);
    await _bookService
        .update(quote)
        .then((b) => ok(b, request))
        .catchError((e) => handleErrors(e, request));
  }

  Book formToBook(BookForm form, String authorId, String bookId) {
    return new Book(bookId, form.title, authorId);
  }
}
