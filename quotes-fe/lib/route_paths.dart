import 'package:angular_router/angular_router.dart';

const authorIdParam = 'authorId';

class RoutePaths {
  static final showAuthor = RoutePath(path: '${listAuthors.path}/show/:$authorIdParam');
  static final editAuthor = RoutePath(path: '${listAuthors.path}/edit/:$authorIdParam');
  static final listAuthors = RoutePath(path: 'authors');
}
