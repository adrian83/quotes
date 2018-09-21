import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives],
)
class ShowAuthorComponent implements OnActivate {

 final AuthorService _authorService;

  Author author = new Author(null, "");
  String errorMessage;

  ShowAuthorComponent(this._authorService);

  @override
  void onActivate(_, RouterState current) async {
    print(current);
    final id = current.parameters[authorIdParam];
    print(id);
    this.author = await _authorService.get(id);
  }



}
