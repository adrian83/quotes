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

  Author author = new Author(null, "");

  EditAuthorComponent(this._authorService);

  @override
  void onActivate(_, RouterState current) async {
    final id = current.parameters[authorIdParam];
    await _authorService
        .get(id)
        .then((a) => this.author = a, onError: handleError);
  }

  void update() async {
    await _authorService
        .update(author)
        .then((author) => showInfo("Author '${author.name}' updated"))
        .catchError(handleError);
  }
}
