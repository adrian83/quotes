import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

@Component(
  selector: 'edit-author',
  templateUrl: 'edit_author.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives],
)
class EditAuthorComponent implements OnActivate {

 final AuthorService _authorService;

  var name = 'Angular';
  Author author = new Author(null, "");
  String errorMessage;

  EditAuthorComponent(this._authorService);

  @override
  void onActivate(_, RouterState current) async {
    print(current);
    final id = current.parameters[authorIdParam];
    print(id);
    this.author = await _authorService.get(id);
  }



}
