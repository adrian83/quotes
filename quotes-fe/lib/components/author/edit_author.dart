import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/navigable.dart';

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
    Events,
    Breadcrumbs,
  ],
)
class EditAuthorComponent extends ErrorHandler
    with Navigable
    implements OnActivate {
  final AuthorService _authorService;

  String _oldName = null;
  Author _author = Author.empty();

  EditAuthorComponent(this._authorService);

  Author get author => _author;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _oldName = _author.name)
      .catchError(handleError);

  void update() => _authorService
      .update(author)
      .then((author) => _author = author)
      .then((_) => showInfo("Author '$_oldName' updated"))
      .then((_) => _oldName = _author.name)
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), _oldName).last());

    return elems;
  }
}
