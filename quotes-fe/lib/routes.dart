import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'components/author/list_authors.template.dart' as list_authors_template;
import 'components/author/show_author.template.dart' as show_author_template;
import 'components/author/edit_author.template.dart' as edit_author_template;
import 'components/author/new_author.template.dart' as new_author_template;
import 'components/author/author_events.template.dart' as author_events_template;

import 'components/book/show_book.template.dart' as show_book_template;
import 'components/book/edit_book.template.dart' as edit_book_template;
import 'components/book/new_book.template.dart' as new_book_template;
import 'components/book/book_events.template.dart' as book_events_template;

import 'components/quote/show_quote.template.dart' as show_quote_template;
import 'components/quote/new_quote.template.dart' as new_quote_template;
import 'components/quote/edit_quote.template.dart' as edit_quote_template;

import 'info.template.dart' as info_template;

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

  static final newAuthor = RouteDefinition(
    routePath: RoutePaths.newAuthor,
    component: new_author_template.NewAuthorComponentNgFactory,
  );

  static final authorEvents = RouteDefinition(
    routePath: RoutePaths.authorEvents,
    component: author_events_template.AuthorEventsComponentNgFactory,
  );

  static final info = RouteDefinition(
    routePath: RoutePaths.info,
    component: info_template.InfoComponentNgFactory,
  );

  static final showBook = RouteDefinition(
    routePath: RoutePaths.showBook,
    component: show_book_template.ShowBookComponentNgFactory,
  );

  static final editBook = RouteDefinition(
    routePath: RoutePaths.editBook,
    component: edit_book_template.EditBookComponentNgFactory,
  );

  static final newBook = RouteDefinition(
    routePath: RoutePaths.newBook,
    component: new_book_template.NewBookComponentNgFactory,
  );

  static final bookEvents = RouteDefinition(
    routePath: RoutePaths.bookEvents,
    component: book_events_template.BookEventsComponentNgFactory,
  );

  static final showQuote = RouteDefinition(
    routePath: RoutePaths.showQuote,
    component: show_quote_template.ShowQuoteComponentNgFactory,
  );

  static final editQuote = RouteDefinition(
    routePath: RoutePaths.editQuote,
    component: edit_quote_template.EditQuoteComponentNgFactory,
  );

  static final newQuote = RouteDefinition(
    routePath: RoutePaths.newQuote,
    component: new_quote_template.NewQuoteComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    listAuthors,
    newAuthor,
    showAuthor,
    editAuthor,
    authorEvents,
    showBook,
    editBook,
    newBook,
    bookEvents,
    showQuote,
    newQuote,
    editQuote,
    info
  ];
}
