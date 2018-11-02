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
import '../../route_paths.dart';

@Component(
  selector: 'new-book',
  templateUrl: 'new_book.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(BookService)],
  directives: const [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class NewBookComponent extends ErrorHandler
    with Navigable
    implements OnActivate {
  final BookService _bookService;
  final AuthorService _authorService;
  final Router _router;

  Book _book = Book.empty();
  Author _author = Author.empty();

  NewBookComponent(this._authorService, this._bookService, this._router);

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    _book.authorId = authorId;

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .catchError(handleError);
  }

  Book get book => _book;
  Author get author => _author;

  void save() => _bookService
      .create(book)
      .then((book) => _book = book)
      .then((_) => _editBook(_book))
      .catchError(handleError);

  void _editBook(Book book) =>
      _router.navigate(editBookUrl(book.authorId, book.id));

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_book.authorId), _author.name),
        Breadcrumb.link(showAuthorUrl(_book.authorId), "books").last(),
      ];
}
