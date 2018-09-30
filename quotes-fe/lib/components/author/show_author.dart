import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class ShowAuthorComponent extends ErrorHandler implements OnActivate {
  final AuthorService _authorService;

  Author author = new Author(null, "");

  ShowAuthorComponent(this._authorService);

  @override
  void onActivate(_, RouterState current) async {
    final id = current.parameters[authorIdParam];
    _authorService.get(id).then((a) => this.author = a, onError: handleError);
  }
}
