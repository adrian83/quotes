import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../route_paths.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';

import '../common/pagination.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives, formDirectives, Pagination],
)
class ListAuthorsComponent extends PageSwitcher implements OnInit {
  final AuthorService _authorService;
  final Router _router;

 static final int pageSize = 3;

  PageRequest _initRequest = new PageRequest(pageSize, 0);
  PageInfo pageInfo = new PageInfo(0, 0, 0);
  AuthorsPage authorsPage;
  String errorMessage;

  ListAuthorsComponent(this._authorService, this._router){
    authorsPage = new AuthorsPage(pageInfo, new List<Author>());
  }

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {
    try {
      authorsPage = await _authorService.list(_initRequest);
      print("offset ${authorsPage.info.offset} limit ${authorsPage.info.limit} total ${authorsPage.info.total}");
      pageInfo.limit = authorsPage.info.limit;
      pageInfo.offset = authorsPage.info.offset;
      pageInfo.total = authorsPage.info.total;
      //print(authorsPage2);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  PageSwitcher get switcher => this;

  @override
  void change(int pageNumber) async {
    print("Page changed $pageNumber");

_initRequest = new PageRequest(pageSize, pageSize*pageNumber);
try {
  authorsPage = await _authorService.list(_initRequest);
  pageInfo.limit = authorsPage.info.limit;
  pageInfo.offset = authorsPage.info.offset;
  pageInfo.total = authorsPage.info.total;
  //print(authorsPage2);
} catch (e) {
  errorMessage = e.toString();
}

  }

  void onSelect(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));

  String _detailsUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});


}
