import 'package:http/browser_client.dart';

import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/routes.dart';
import 'package:quotesfe/tools/config.dart';

void main() {
  var browserClient = BrowserClient();

  var config = Config("http://localhost:5050");

  var authorService = AuthorService(browserClient, config);
  var bookService = BookService(browserClient, config);
  var quoteService = QuoteService(browserClient, config);

  final routes = RouteConfiguration(authorService, bookService, quoteService);

  runApp(QuotesApp(null, "", routes));
}

class QuotesApp extends StatelessWidget {
  final RouteConfiguration routes;
  final String initialRoute;

  const QuotesApp(Key? key, this.initialRoute, this.routes) : super(key: key);

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return routes.onGenerateRoute(settings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior(),
      restorationScopeId: 'rootQuotes',
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
