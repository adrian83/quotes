import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:quotes_fe/domain/author/model.dart';
import 'package:quotes_fe/domain/author/service.dart';
import 'package:quotes_fe/domain/common/event.dart';
import 'package:quotes_fe/domain/common/router.dart';
import 'package:quotes_fe/route_paths.dart';
import 'package:quotes_fe/routes.dart';
import 'package:quotes_fe/components/common/breadcrumb.dart';
import 'package:quotes_fe/components/common/error_handler.dart';
import 'package:quotes_fe/components/common/events.dart';

@Component(
  selector: 'edit-author',
  templateUrl: 'edit_author.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
  ],
)
class EditAuthorComponent implements OnActivate {
  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  String _oldName = null;
  Author _author = Author.empty();

  EditAuthorComponent(this._authorService, this._errorHandler, this._router);

  Author get author => _author;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _oldName = _author.name)
      .catchError(_errorHandler.handleError);

  void update() => _authorService
      .update(author)
      .then((author) => _author = author)
      .then((_) => _errorHandler.showInfo("Author '$_oldName' updated"))
      .then((_) => _oldName = _author.name)
      .catchError(_errorHandler.handleError);

  void showAuthor() => _router.showAuthor(_author.id);

  void showEvents() => _router.showAuthorEvents(_author.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _oldName).last());
    }
    return elems;
  }
}
