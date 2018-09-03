import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';

import 'route_paths.dart';

import 'domain/author/service.dart';
import 'domain/author/model.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives],
)
class ListAuthorsComponent implements OnInit {
 final AuthorService _authorService;
 final Router _router;

  var name = 'Angular';
  List<Author> authors = [];
  String errorMessage;

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {
    try {
      authors = await _authorService.getAll();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  void onSelect(Author author) => _gotoDetail(author.id);

  String _authorUrl(String id) =>
      RoutePaths.author.toUrl(parameters: {authorIdParam: '$id'});

  Future<NavigationResult> _gotoDetail(String id) =>
      _router.navigate(_authorUrl(id));

}
