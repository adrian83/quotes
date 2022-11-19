import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/author/list_events.dart';
import 'package:quotesfe/pages/book/delete_book.dart';
import 'package:quotesfe/pages/book/list_events.dart';
import 'package:quotesfe/pages/quote/list_events.dart';
import 'package:quotesfe/pages/quote/new_quote.dart';
import 'package:quotesfe/pages/quote/show_quote.dart';
import 'package:quotesfe/pages/quote/update_quote.dart';
import 'package:quotesfe/pages/quote/delete_quote.dart';
import 'package:quotesfe/pages/search.dart';
import 'package:quotesfe/pages/author/show_author.dart';
import 'package:quotesfe/pages/author/update_author.dart';
import 'package:quotesfe/pages/author/delete_author.dart';
import 'package:quotesfe/pages/author/new_author.dart';
import 'package:quotesfe/pages/book/show_book.dart';
import 'package:quotesfe/pages/book/new_book.dart';
import 'package:quotesfe/pages/book/update_book.dart';
import 'package:quotesfe/paths.dart';

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
          searchPathPattern,
          (context, match) => SearchPage(
              UniqueKey(),
              "search",
              _authorService,
              _bookService,
              _quoteService,
              getParam(match, "searchPhrase", ""))),
      Path(
          authorCreatePathPattern,
          (context, match) =>
              NewAuthorPage(null, "new author", _authorService)),
      Path(
          authorUpdatePathPattern,
          (context, match) => UpdateAuthorPage(null, "update author",
              extractPathElement(match, 3), _authorService)),
      Path(
          authorDeletePathPattern,
          (context, match) => DeleteAuthorPage(null, "delete author",
              extractPathElement(match, 3), _authorService)),
      Path(
          authorShowPathPattern,
          (context, match) => ShowAuthorPage(null, "show author",
              extractPathElement(match, 3), _authorService)),
      Path(
          authorEventsPathPattern,
          (context, match) => ListAuthorEventsPage(null, "author events",
              extractPathElement(match, 3), _authorService)),
      Path(
          bookCreatePathPattern,
          (context, match) => NewBookPage(
              null, "new author", extractPathElement(match, 3), _bookService)),
      Path(
          bookShowPathPattern,
          (context, match) => ShowBookPage(
              null,
              "show book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          bookUpdatePathPattern,
          (context, match) => UpdateBookPage(
              null,
              "update book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          bookDeletePathPattern,
          (context, match) => DeleteBookPage(
              null,
              "delete book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          bookEventsPathPattern,
          (context, match) => ListBookEventsPage(
              null,
              "book events",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(
          quoteCreatePathPattern,
          (context, match) => NewQuotePage(
              null,
              "new quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _quoteService)),
      Path(
          quoteShowPathPattern,
          (context, match) => ShowQuotePage(
              null,
              "delete quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          quoteDeletePathPattern,
          (context, match) => DeleteQuotePage(
              null,
              "delete quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          quoteUpdatePathPattern,
          (context, match) => UpdateQuotePage(
              null,
              "update quote",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          quoteEventsPathPattern,
          (context, match) => ListQuoteEventsPage(
              null,
              "quote events",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              extractPathElement(match, 9),
              _quoteService)),
      Path(
          r'^/',
          (context, match) => SearchPage(
              UniqueKey(),
              "search",
              _authorService,
              _bookService,
              _quoteService,
              getParam(match, "searchPhrase", ""))),
    ];
  }

  String getParam(String path, String name, String def) {
    final settingsUri = Uri.parse(path);
//settingsUri.queryParameters is a map of all the query keys and values
    final value = settingsUri.queryParameters[name];
    return value ?? def;
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
