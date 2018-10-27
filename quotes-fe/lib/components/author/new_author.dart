import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'new-author',
  templateUrl: 'new_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class NewAuthorComponent extends ErrorHandler implements OnActivate {
  final AuthorService _authorService;

  Author _author = new Author(null, "");

  NewAuthorComponent(this._authorService);

  @override
  void onActivate(_, RouterState current) async {}

  Author get author => _author;

  void save() {
    _authorService
        .create(author)
        .then((author) => _author = author)
        .catchError(handleError);
  }
}
