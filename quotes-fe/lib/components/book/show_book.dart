import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:logging/logging.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';

import '../common/error_handler.dart';
import '../../domain/common/page.dart';
import '../common/pagination.dart';
import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'show-book',
  templateUrl: 'show_book.template.html',
  providers: [ClassProvider(BookService)],
  directives: const [
    coreDirectives,
    Pagination,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class ShowBookComponent extends ErrorHandler with OnActivate {
  static final Logger logger = new Logger('ShowBookComponent');

  static final int pageSize = 2;

  final BookService _bookService;

  Book _book = Book(null, "", null, null);

  ShowBookComponent(this._bookService);

  Book get book => _book;

  @override
  Future<void> onActivate(_, RouterState current) async {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    logger.info("Show book with id: $bookId");
_book = await _bookService.get(authorId, bookId).catchError(handleError);
  }


}
