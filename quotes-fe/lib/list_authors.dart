import 'package:angular/angular.dart';
import 'dart:async';

import 'domain/author/service.dart';
import 'domain/author/model.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
)
class ListAuthorsComponent implements OnInit {
 final AuthorService _authorService;

  var name = 'Angular';
 List<Author> authors = [];
  String errorMessage;

  ListAuthorsComponent(this._authorService);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {
    try {
      authors = await _authorService.getAll();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

}
