import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'components/author/list_authors.template.dart' as list_authors_template;
import 'components/author/show_author.template.dart' as show_author_template;
import 'components/author/edit_author.template.dart' as edit_author_template;

export 'route_paths.dart';

class Routes {

  static final listAuthors = RouteDefinition(
    routePath: RoutePaths.listAuthors,
    component: list_authors_template.ListAuthorsComponentNgFactory,
  );

  static final showAuthor = RouteDefinition(
    routePath: RoutePaths.showAuthor,
    component: show_author_template.ShowAuthorComponentNgFactory,
  );

  static final editAuthor = RouteDefinition(
    routePath: RoutePaths.editAuthor,
    component: edit_author_template.EditAuthorComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    listAuthors, showAuthor, editAuthor
  ];
}
