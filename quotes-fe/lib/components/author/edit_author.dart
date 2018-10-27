import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'edit-author',
  templateUrl: 'edit_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class EditAuthorComponent extends ErrorHandler implements OnActivate {
  final AuthorService _authorService;

  Author _author = new Author(null, "");

  EditAuthorComponent(this._authorService);

  Author get author => _author;

  @override
  void onActivate(_, RouterState current) {
    final id = current.parameters[authorIdParam];
    _authorService
        .get(id)
        .then((author) => _author = author)
        .catchError(handleError);
  }

  void update() {
     _authorService
        .update(author)
        .then((author) => showInfo("Author '${author.name}' updated"))
        .catchError(handleError);
  }
}
