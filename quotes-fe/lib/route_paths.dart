import 'package:angular_router/angular_router.dart';

const authorIdParam = 'authorId';

class RoutePaths {
  static final author = RoutePath(path: '${authors.path}/:$authorIdParam');
  static final authors = RoutePath(path: 'authors');
}
