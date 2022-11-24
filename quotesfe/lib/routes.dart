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
      Path(searchPathPattern, searchView),
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
              extractPathElement(match, 3), _authorService, _bookService)),
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
              _bookService,
              _quoteService)),
      Path(
          bookUpdatePathPattern,
          (context, match) => UpdateBookPage(
              null,
              "update book",
              extractPathElement(match, 3),
              extractPathElement(match, 6),
              _bookService)),
      Path(bookDeletePathPattern, deleteBookView),
      Path(bookEventsPathPattern, listBookEventsView),
      Path(quoteCreatePathPattern, createQuoteView),
      Path(quoteShowPathPattern, showQuoteView),
      Path(quoteDeletePathPattern, deleteQuoteView),
      Path(quoteUpdatePathPattern, updateQuoteView),
      Path(quoteEventsPathPattern, listQuoteEventsView),
      Path(r'^/', searchView),
    ];
  }

  Widget deleteBookView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6]);
    return DeleteBookPage(
        null, "delete book", pathParams[0], pathParams[1], _bookService);
  }

  Widget listBookEventsView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6]);
    return ListBookEventsPage(
        null, "book events", pathParams[0], pathParams[1], _bookService);
  }

  Widget createQuoteView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6]);
    return NewQuotePage(
        null, "new quote", pathParams[0], pathParams[1], _quoteService);
  }

  Widget showQuoteView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6, 9]);
    return ShowQuotePage(null, "delete quote", pathParams[0], pathParams[1],
        pathParams[2], _quoteService);
  }

  Widget deleteQuoteView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6, 9]);
    return DeleteQuotePage(null, "delete quote", pathParams[0], pathParams[1],
        pathParams[2], _quoteService);
  }

  Widget updateQuoteView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6, 9]);
    return UpdateQuotePage(null, "update quote", pathParams[0], pathParams[1],
        pathParams[2], _quoteService);
  }

  Widget listQuoteEventsView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6, 9]);
    return ListQuoteEventsPage(null, "quote events", pathParams[0],
        pathParams[1], pathParams[2], _quoteService);
  }

  Widget searchView(BuildContext ctx, String path) {
    return SearchPage(UniqueKey(), "search", _authorService, _bookService,
        _quoteService, getUrlParam(path, "searchPhrase", ""));
  }

  String getUrlParam(String path, String name, String def) {
    final settingsUri = Uri.parse(path);
    final value = settingsUri.queryParameters[name];
    return value ?? def;
  }

  String extractPathElement(String path, int no) {
    var elem = path.split("/")[no];
    return elem.split("?")[0];
  }

  List<String> extractPathElements(String path, List<int> indexes) {
    var elements = path.split("?")[0].split("/");
    var values = <String>[];
    for (int i = 0; i < elements.length; i++) {
      if (indexes.contains(i)) {
        values.add(elements[i]);
      }
    }
    return values;
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
