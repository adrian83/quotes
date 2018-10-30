import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error.dart';
import '../common/error_handler.dart';
import '../common/info.dart';
import '../common/validation.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../routes.dart';
import '../../route_paths.dart';

@Component(
  selector: 'edit-author',
  templateUrl: 'edit_author.template.html',
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
class EditAuthorComponent extends ErrorHandler implements OnActivate {
  final AuthorService _authorService;

  String _oldName = null;
  Author _author = new Author(null, "");

  EditAuthorComponent(this._authorService);

  Author get author => _author;

  @override
  void onActivate(_, RouterState current) {
    final id = current.parameters[authorIdParam];
    _authorService
        .get(id)
        .then((author) => _author = author)
        .then((_) => _oldName = _author.name)
        .catchError(handleError);
  }

  void update() {
    _authorService
        .update(author)
        .then((author) => _author = author)
        .then((_) => showInfo("Author '$_oldName' updated"))
        .then((_) => _oldName = _author.name)
        .catchError(handleError);
  }

  String _listAuthorsUrl() => RoutePaths.listAuthors.toUrl();

  String _showAuthorUrl() => RoutePaths.showAuthor
      .toUrl(parameters: {authorIdParam: _author.id ?? "-"});

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb(_listAuthorsUrl(), "authors", true, false),
        Breadcrumb(_showAuthorUrl(), _oldName, true, true),
      ];
}
