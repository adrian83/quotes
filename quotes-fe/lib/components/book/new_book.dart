import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../route_paths.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'new-book',
  templateUrl: 'new_book.template.html',
  providers: [ClassProvider(BookService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class NewBookComponent extends ErrorHandler implements OnActivate {
  final BookService _bookService;
  final Router _router;

  Book _book = new Book(null, "", null);

  NewBookComponent(this._bookService, this._router);

  @override
  void onActivate(_, RouterState current) async {
    _book.authorId = current.parameters[authorIdParam];
  }

  Book get book => _book;

  void save() {
    _bookService
        .create(book)
        .then((book) => _book = book)
        .then((_) => _edit(_book))
        .catchError(handleError);
  }

  String _editionUrl(String authorId, String bookId) => RoutePaths.editBook
      .toUrl(parameters: {authorIdParam: authorId, bookIdParam: bookId});

  void _edit(Book book) =>
      _router.navigate(_editionUrl(book.authorId, book.id));
}
