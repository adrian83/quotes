import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'list_authors.template.dart' as list_authors_template;
import 'show_author.template.dart' as show_author_template;

export 'route_paths.dart';



class Routes {

  static final authors = RouteDefinition(
    routePath: RoutePaths.authors,
    component: list_authors_template.ListAuthorsComponentNgFactory,
  );

  static final showAuthor = RouteDefinition(
    routePath: RoutePaths.author,
    component: show_author_template.ShowAuthorComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    authors, showAuthor,
  ];
}
