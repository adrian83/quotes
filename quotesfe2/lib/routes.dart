import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/demo.dart';
import 'package:quotesfe2/pages/home.dart';
import 'package:quotesfe2/pages/search.dart';
import 'package:quotesfe2/pages/authors.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, String);

class Path {
  const Path(this.pattern, this.builder);

  final String pattern;
  final PathWidgetBuilder builder;
}

class RouteConfiguration {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;

  const RouteConfiguration(
      this._authorService, this._bookService, this._quoteService);

  List<Path> paths() {
    return [
      Path(
          SearchPage.routePattern,
          (context, match) => SearchPage(
              null, "search", _authorService, _bookService, _quoteService)),
      Path(NewAuthorPage.routePattern,
          (context, match) => NewAuthorPage(null, "new author", _authorService)),
      Path(
          ShowAuthorPage.routePattern,
          (context, match) =>
              ShowAuthorPage(null, "show author", extractPathElement(match, 3))),
      Path(
          r'^' + DemoPage.baseRoute + r'/?([\w-]+)$',
          (context, match) => SearchPage(null, "search", _authorService,
              _bookService, _quoteService)), //const DemoPage()),
      Path(
          r'^/',
          (context, match) => SearchPage(null, "search", _authorService,
              _bookService, _quoteService)), //const HomePage(null, "Home")),
    ];
  }

  String extractPathElement(String path, int no) {
    print("path $path");
    var parts = path.split("\\");
    var elem = parts[no+1];
    var ps = elem.split("?");
    return ps[0];
  }

/*
const authorIdParam = "authorId";
const bookIdParam = "bookId";
const quoteIdParam = "quoteId";

class RoutePaths {
  static final newAuthorPath = 'authors/new';
  static final showAuthorPath = 'authors/show/:$authorIdParam';
  static final editAuthorPath = 'authors/edit/:$authorIdParam';
  static final authorEventsPath = 'authors/events/:$authorIdParam';

  static final newAuthor = RoutePath(path: newAuthorPath);
  static final showAuthor = RoutePath(path: showAuthorPath);
  static final editAuthor = RoutePath(path: editAuthorPath);
  static final authorEvents = RoutePath(path: authorEventsPath);

  static final newBookPath = 'authors/show/:$authorIdParam/books/new';
  static final showBookPath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam';
  static final editBookPath = 'authors/show/:$authorIdParam/books/edit/:$bookIdParam';
  static final bookEventsPath = 'authors/show/:$authorIdParam/books/events/:$bookIdParam';

  static final newBook = RoutePath(path: newBookPath);
  static final showBook = RoutePath(path: showBookPath);
  static final editBook = RoutePath(path: editBookPath);
  static final bookEvents = RoutePath(path: bookEventsPath);

  static final newQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/new';
  static final showQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/show/:$quoteIdParam';
  static final editQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/edit/:$quoteIdParam';
  static final quoteEventsPath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/events/:$quoteIdParam';

  static final newQuote = RoutePath(path: newQuotePath);
  static final showQuote = RoutePath(path: showQuotePath);
  static final editQuote = RoutePath(path: editQuotePath);
  static final quoteEvents = RoutePath(path: quoteEventsPath);

  static final info = RoutePath(path: 'info');
  static final search = RoutePath(path: '');
}

*/


  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
      var name = settings.name;
      print("name $name");

    for (final path in paths()) {
      final regExpPattern = RegExp(path.pattern);

      if (name == null) {
        return NoAnimationMaterialPageRoute<void>(
          (context) => path.builder(context, "test-match"),
          settings,
        );
      }

      if (regExpPattern.hasMatch(name)) {
        final firstMatch = regExpPattern.firstMatch(name);
        print("firstMatch ${path.pattern}");

        final match =
            (firstMatch?.groupCount == 1) ? firstMatch?.group(1) : null;
        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            (context) => path.builder(context, "test-match2"),
            settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, "test-match3"),
          settings: settings,
        );
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute(
    WidgetBuilder builder,
    RouteSettings settings,
  ) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
