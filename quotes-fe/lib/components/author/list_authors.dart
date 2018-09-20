import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../route_paths.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives],
)
class ListAuthorsComponent implements OnInit {

 final AuthorService _authorService;
 final Router _router;

  List<Author> authors = [];
  String errorMessage;

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {
    print("ListAuthorsComponent");

    try {
      var request = new PageRequest(0, null);
      var authorsPage = await _authorService.list(request);
      authors = authorsPage.elements;
    } catch (e) {
      errorMessage = e.toString();
    }

  }

  void onSelect(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));

  String _detailsUrl(String id) => RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) => RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});




}
