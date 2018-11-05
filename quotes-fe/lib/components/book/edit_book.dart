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

  String _oldTitle = "";
  Book _book = Book.empty();
  Author _author = Author.empty();

  EditBookComponent(this._authorService, this._bookService);

  Book get book => _book;
  Author get author => _author;

  @override
  void onActivate(_, RouterState router) => _authorService
      .get(router.parameters[authorIdParam])
      .then((author) => _author = author)
      .then((author) => _bookService.get(author.id, param(bookIdParam, router)))
      .then((book) => _book = book)
      .then((_) => _oldTitle = _book.title)
      .catchError(handleError);

  void update() => _bookService
      .update(_book)
      .then((book) => _book = book)
      .then((_) => showInfo("Book '$_oldTitle' updated"))
      .then((_) => _oldTitle = _book.title)
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), _author.name));
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), "books"));

    if (_book.id != null) return elems;
    elems.add(
        Breadcrumb.link(showBookUrl(_author.id, _book.id), _oldTitle).last());

    return elems;
  }
}
