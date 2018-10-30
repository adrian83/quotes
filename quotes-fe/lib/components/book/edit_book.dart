import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/error.dart';
import '../common/error_handler.dart';
import '../common/info.dart';
import '../common/validation.dart';

import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../routes.dart';

@Component(
  selector: 'edit-book',
  templateUrl: 'edit_book.template.html',
  providers: [ClassProvider(BookService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class EditBookComponent extends ErrorHandler implements OnActivate {
  final BookService _bookService;

  String _oldTitle = null;
  Book _book = new Book(null, "", null);

  EditBookComponent(this._bookService);

  Book get book => _book;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .then((_) => _oldTitle = _book.title)
        .catchError(handleError);
  }

  void update() {
    _bookService
        .update(_book)
        .then((book) => _book = book)
        .then((_) => showInfo("Book '$_oldTitle' updated"))
        .then((_) => _oldTitle = _book.title)
        .catchError(handleError);
  }
}
