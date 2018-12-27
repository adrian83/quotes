import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

@Component(
  selector: 'new-author',
  templateUrl: 'new_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives, formDirectives, Events, Breadcrumbs],
)
class NewAuthorComponent extends ErrorHandler with Navigable {
  final AuthorService _authorService;
  final Router _router;

  Author _author = Author.empty();

  NewAuthorComponent(this._authorService, this._router);

  Author get author => _author;

  void save() => _authorService
      .create(author)
      .then((author) => _author = author)
      .then((_) => _editAuthor(_author))
      .catchError(handleError);

  void _editAuthor(Author author) => _router.navigate(editAuthorUrl(author.id));

  List<Breadcrumb> get breadcrumbs =>
      [Breadcrumb.link(search(), "search").last()];
}
