import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../route_paths.dart';

@Component(
  selector: 'new-author',
  templateUrl: 'new_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    Breadcrumbs,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class NewAuthorComponent extends ErrorHandler {
  final AuthorService _authorService;
  final Router _router;

  Author _author = new Author(null, "");

  NewAuthorComponent(this._authorService, this._router);

  Author get author => _author;

  void save() {
    _authorService
        .create(author)
        .then((author) => _author = author)
        .then((_) => _editAuthor(_author))
        .catchError(handleError);
  }

  String _listAuthorsUrl() => RoutePaths.listAuthors.toUrl();

  String _editAuthorUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: id});

  void _editAuthor(Author author) =>
      _router.navigate(_editAuthorUrl(author.id));

  List<Breadcrumb> get breadcrumbs =>
      [Breadcrumb(_listAuthorsUrl(), "authors", true, true)];
}
