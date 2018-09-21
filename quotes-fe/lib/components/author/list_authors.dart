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

PageRequest _initRequest = new PageRequest(3, 0);
  AuthorsPage authorsPage = new AuthorsPage(new PageInfo(0, 0, 0), new List<Author>());
  String errorMessage;

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {

    try {
      authorsPage = await _authorService.list(_initRequest);
      //print(authorsPage2);
    } catch (e) {
      errorMessage = e.toString();
    }

  }

  void onSelect(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));

  String _detailsUrl(String id) => RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) => RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});




}
