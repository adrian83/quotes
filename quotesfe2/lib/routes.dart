import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/search.dart';
import 'package:quotesfe2/pages/author/show_author_page.dart';
import 'package:quotesfe2/pages/author/update_author_page.dart';
import 'package:quotesfe2/pages/author/new_author_page.dart';
import 'package:quotesfe2/pages/books.dart';

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

  const RouteConfiguration(this._authorService, this._bookService, this._quoteService);

  List<Path> paths() {
    return [
      Path(SearchPage.routePattern, (context, match) => SearchPage(UniqueKey(), "search", _authorService, _bookService, _quoteService)),
      Path(NewAuthorPage.routePattern, (context, match) => NewAuthorPage(null, "new author", _authorService)),
      Path(UpdateAuthorPage.routePattern, (context, match) => UpdateAuthorPage(null, "update author", extractPathElement(match, 3), _authorService)),
      Path(ShowAuthorPage.routePattern, (context, match) => ShowAuthorPage(null, "show author", extractPathElement(match, 3), _authorService)),
      Path(NewBookPage.routePattern, (context, match) => NewBookPage(null, "new author", extractPathElement(match, 3), _bookService)),
      Path(ShowBookPage.routePattern, (context, match) => ShowBookPage(null, "show book", extractPathElement(match, 3), extractPathElement(match, 6), _bookService)),
      Path(r'^/', (context, match) => SearchPage(UniqueKey(), "search", _authorService, _bookService, _quoteService)), 
    ];
  }

  String extractPathElement(String path, int no) {
    var elem = path.split("/")[no];
    return elem.split("?")[0];
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

  static final newBookPath = 'authors/show/:$authorIdParam/books/new';
  static final showBookPath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam';
  static final editBookPath = 'authors/show/:$authorIdParam/books/edit/:$bookIdParam';
  static final bookEventsPath = 'authors/show/:$authorIdParam/books/events/:$bookIdParam';

  static final newQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/new';
  static final showQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/show/:$quoteIdParam';
  static final editQuotePath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/edit/:$quoteIdParam';
  static final quoteEventsPath = 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/events/:$quoteIdParam';

  static final info = RoutePath(path: 'info');
  static final search = RoutePath(path: '');
*/


  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
      var name = settings.name;
      developer.log("route name: $name");

    for (final path in paths()) {
      final regExpPattern = RegExp(path.pattern);

      if (name == null) {
        return NoAnimationMaterialPageRoute<void>(
          (context) => path.builder(context, name!),
          settings,
        );
      }

      if (regExpPattern.hasMatch(name)) {
        print("matched ${path.pattern} with $name");
        //final firstMatch = regExpPattern.firstMatch(name);

        //final match = (firstMatch?.groupCount == 1) ? firstMatch?.group(1) : null;
        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            (context) => path.builder(context, name),
            settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, name),
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
