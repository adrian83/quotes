import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/author/list_events.dart';
import 'package:quotesfe2/pages/book/delete_book.dart';
import 'package:quotesfe2/pages/book/list_events.dart';
import 'package:quotesfe2/pages/quote/list_events.dart';
import 'package:quotesfe2/pages/quote/update_quote.dart';
import 'package:quotesfe2/pages/quote/delete_quote.dart';
import 'package:quotesfe2/pages/search.dart';
import 'package:quotesfe2/pages/author/show_author.dart';
import 'package:quotesfe2/pages/author/update_author.dart';
import 'package:quotesfe2/pages/author/delete_author.dart';
import 'package:quotesfe2/pages/author/new_author.dart';
import 'package:quotesfe2/pages/book/show_book.dart';
import 'package:quotesfe2/pages/book/new_book.dart';
import 'package:quotesfe2/pages/book/update_book.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, String);

class Path {
  final String pattern;
  final PathWidgetBuilder builder;

  const Path(this.pattern, this.builder);
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
          (context, match) => SearchPage(UniqueKey(), "search", _authorService,
              _bookService, _quoteService)),
      Path(
          NewAuthorPage.routePattern,
          (context, match) =>
              NewAuthorPage(null, "new author", _authorService)),
      Path(
          UpdateAuthorPage.routePattern,
          (context, match) => UpdateAuthorPage(null, "update author",
              extractPathElement(match, 3), _authorService)),
      Path(
          DeleteAuthorPage.routePattern,
          (context, match) => DeleteAuthorPage(null, "delete author",
              extractPathElement(match, 3), _authorService)),
      Path(
          ShowAuthorPage.routePattern,
          (context, match) => ShowAuthorPage(null, "show author",
              extractPathElement(match, 3), _authorService)),
      Path(
          ListAuthorEventsPage.routePattern,
          (context, match) => ListAuthorEventsPage(null, "author events",
              extractPathElement(match, 3), _authorService)),
      Path(
          NewBookPage.routePattern,
          (context, match) => NewBookPage(
              null, "new author", extractPathElement(match, 3), _bookService)),
      Path(
          ShowBookPage.routePattern,
          (context, match) => ShowBookPage(
              null,
              "show book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          UpdateBookPage.routePattern,
          (context, match) => UpdateBookPage(
              null,
              "update book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          DeleteBookPage.routePattern,
          (context, match) => DeleteBookPage(
              null,
              "delete book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          ListBookEventsPage.routePattern,
          (context, match) => ListBookEventsPage(
              null,
              "book events",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          DeleteQuotePage.routePattern,
          (context, match) => DeleteQuotePage(
              null,
              "delete quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          UpdateQuotePage.routePattern,
          (context, match) => UpdateQuotePage(
              null,
              "update quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          ListQuoteEventsPage.routePattern,
          (context, match) => ListQuoteEventsPage(
              null,
              "quote events",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          r'^/',
          (context, match) => SearchPage(UniqueKey(), "search", _authorService,
              _bookService, _quoteService)),
    ];
  }

  String extractPathElement(String path, int no) {
    var elem = path.split("/")[no];
    return elem.split("?")[0];
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    var name = settings.name;
    //print("route name: $name");

    for (final path in paths()) {
      final regExpPattern = RegExp(path.pattern);

      if (name == null) {
        return NoAnimationMaterialPageRoute<void>(
          (context) => path.builder(context, name!),
          settings,
        );
      }

      //print("try match: ${path.pattern} $name");
      if (regExpPattern.hasMatch(name)) {
        //print("match: ${path.pattern} $name");
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
