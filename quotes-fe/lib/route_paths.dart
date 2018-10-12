import 'package:angular_router/angular_router.dart';

const authorIdParam = 'authorId';

class RoutePaths {
  static final newAuthor = RoutePath(path: '${listAuthors.path}/new');
  static final showAuthor = RoutePath(path: '${listAuthors.path}/show/:$authorIdParam');
  static final editAuthor = RoutePath(path: '${listAuthors.path}/edit/:$authorIdParam');
  static final listAuthors = RoutePath(path: 'authors');
  static final info = RoutePath(path: 'info');
}
