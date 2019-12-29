import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/router.dart';
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../../domain/common/event.dart';

@Component(
  selector: 'edit-book',
  templateUrl: 'edit_book.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(BookService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class EditBookComponent extends ErrorHandler implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  String _oldTitle = "";
  Book _book = Book.empty();
  Author _author = Author.empty();

  EditBookComponent(this._authorService, this._bookService, this._errorHandler, this._router);

  Book get book => _book;
  Author get author => _author;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(state.parameters[authorIdParam])
      .then((author) => _author = author)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.find(_author.id, bookId))
      .then((book) => _book = book)
      .then((_) => _oldTitle = _book.title)
      .catchError(handleError);

  void update() => _bookService
      .update(_book)
      .then((book) => _book = book)
      .then((_) => showInfo("Book '$_oldTitle' updated"))
      .then((_) => _oldTitle = _book.title)
      .catchError(handleError);

  void showBook() => _router.showBook(_author.id, _book.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _author.name));
    }

    if (_book.id != null) {
      var url = _router.showBookUrl(_author.id, _book.id);
      elems.add(Breadcrumb.link(url, _oldTitle).last());
    }
    return elems;
  }
}
