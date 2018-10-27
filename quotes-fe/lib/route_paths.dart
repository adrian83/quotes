import 'package:angular_router/angular_router.dart';

const authorIdParam = 'authorId';
const bookIdParam = 'bookId';

class RoutePaths {
  static final listAuthors = RoutePath(path: 'authors');
  static final newAuthor = RoutePath(path: '${listAuthors.path}/new');
  static final showAuthor =
      RoutePath(path: '${listAuthors.path}/show/:$authorIdParam');
  static final editAuthor =
      RoutePath(path: '${listAuthors.path}/edit/:$authorIdParam');

  static final showBook = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/show/:$bookIdParam');
  static final editBook = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/edit/:$bookIdParam');

  static final info = RoutePath(path: 'info');
}
