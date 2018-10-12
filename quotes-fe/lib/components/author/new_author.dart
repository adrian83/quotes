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

  final Router _router;

  Author author = new Author(null, "");

  NewAuthorComponent(this._authorService, this._router);

  @override
  void onActivate(_, RouterState current) async {}

  void save() {
    _authorService
        .create(author)
        .then((a) => onSelect(a), onError: handleError);
  }

  void onSelect(Author author) => _router.navigate(_detailsUrl(author.id));

  String _detailsUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});
}
