import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'list_authors.template.dart' as list_authors_template;

export 'route_paths.dart';

class Routes {
  static final authors = RouteDefinition(
    routePath: RoutePaths.authors,
    component: list_authors_template.ListAuthorsComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    authors,
  ];
}
