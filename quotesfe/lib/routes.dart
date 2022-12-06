import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/domain/common/service.dart';
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
      Path(authorCreatePathPattern, createAuthorView),
      Path(authorUpdatePathPattern, updateAuthorView),
      Path(authorDeletePathPattern, deleteAuthorView),
      Path(authorShowPathPattern, showAuthorView),
      Path(authorEventsPathPattern, listAuthorEventsView),
      Path(bookCreatePathPattern, createBookView),
      Path(bookShowPathPattern, showBookView),
      Path(bookUpdatePathPattern, updateBookView),
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

  Widget createAuthorView(BuildContext ctx, String path) {
    return NewAuthorPage(null, "new author", _authorService);
  }

  Widget updateAuthorView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3]);
    return UpdateAuthorPage(
        null, "update author", pathParams[0], _authorService);
  }

  Widget deleteAuthorView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3]);
    return DeleteAuthorPage(
        null, "delete author", pathParams[0], _authorService);
  }

  Widget showAuthorView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3]);
    return ShowAuthorPage(
        null, "show author", pathParams[0], _authorService, _bookService);
  }

  Widget listAuthorEventsView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3]);
    return ListAuthorEventsPage(
        null, "author events", pathParams[0], _authorService);
  }

  Widget createBookView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3]);
    return NewBookPage(null, "new author", pathParams[0], _bookService);
  }

  Widget showBookView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6]);
    return ShowBookPage(null, "show book", pathParams[0], pathParams[1],
        _bookService, _quoteService);
  }

  Widget updateBookView(BuildContext ctx, String path) {
    var pathParams = extractPathElements(path, [3, 6]);
    return UpdateBookPage(
        null, "update book", pathParams[0], pathParams[1], _bookService);
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
        _quoteService, getUrlParam(path, paramSearchPhrase, ""));
  }

  String getUrlParam(String path, String name, String def) {
    final settingsUri = Uri.parse(path);
    final value = settingsUri.queryParameters[name];
    return value ?? def;
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

    for (final path in paths()) {
      final regExpPattern = RegExp(path.pattern);

      if (name == null) {
        return NoAnimationMaterialPageRoute<void>(
          (context) => path.builder(context, name!),
          settings,
        );
      }

      if (regExpPattern.hasMatch(name)) {
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
