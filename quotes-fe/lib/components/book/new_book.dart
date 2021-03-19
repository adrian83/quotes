import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/router.dart';
import '../../route_paths.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';

@Component(
  selector: 'new-book',
  templateUrl: 'new_book.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class NewBookComponent implements OnActivate {
  final BookService _bookService;
  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Book _book = Book.empty();
  Author _author = Author.empty();

  NewBookComponent(this._authorService, this._bookService, this._errorHandler, this._router);

  Book get book => _book;
  Author get author => _author;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _book.authorId = _author.id)
      .catchError(_errorHandler.handleError);

  void save() => _bookService
      .create(book)
      .then((book) => _book = book)
      .then((_) => _editBook(_book))
      .catchError(_errorHandler.handleError);

  void _editBook(Book book) => _router.editBook(book.authorId, book.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _author.name));
    }
    return elems;
  }
}
