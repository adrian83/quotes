import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:logging/logging.dart';

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
  static final Logger logger = new Logger('ShowAuthorComponent');

  final AuthorService _authorService;

  Author _author = new Author(null, "");

  ShowAuthorComponent(this._authorService);

  Author get author => _author;

  @override
  Future<void> onActivate(_, RouterState current) async {
    var id = current.parameters[authorIdParam];
    logger.info("Show author with id: $id");
    _author = await _authorService.get(id).catchError(handleError);
  }
}
