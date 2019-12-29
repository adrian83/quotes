import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/router.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';

@Component(
  selector: 'new-author',
  templateUrl: 'new_author.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Events, Breadcrumbs],
)
class NewAuthorComponent {
  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();

  NewAuthorComponent(this._authorService, this._errorHandler, this._router);

  Author get author => _author;
  List<Event> get events => _errorHandler.events;

  void save() => _authorService.create(author).then((author) => _author = author).then((_) => _editAuthor(_author)).catchError(_errorHandler.handleError);

  void _editAuthor(Author author) => _router.editAuthor(author.id);

  List<Breadcrumb> get breadcrumbs => [Breadcrumb.link(_router.search(), "search").last()];
}
