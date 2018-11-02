import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../routes.dart';

@Component(
  selector: 'edit-book',
  templateUrl: 'edit_book.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(BookService)],
  directives: const [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class EditBookComponent extends ErrorHandler
    with Navigable
    implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;

  String _oldTitle = null;
  Book _book = Book(null, "", null);
  Author _author = Author(null, "");

  EditBookComponent(this._authorService, this._bookService);

  Book get book => _book;
  Author get author => _author;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .then((_) => _oldTitle = _book.title)
        .catchError(handleError);

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .catchError(handleError);
  }

  void update() => _bookService
      .update(_book)
      .then((book) => _book = book)
      .then((_) => showInfo("Book '$_oldTitle' updated"))
      .then((_) => _oldTitle = _book.title)
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_book.authorId), _author.name),
        Breadcrumb.link(showAuthorUrl(_book.authorId), "books"),
        Breadcrumb.link(showBookUrl(_book.authorId, _book.id), _oldTitle).last(),
      ];
}
