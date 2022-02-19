import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';

import 'package:http/browser_client.dart';

import 'package:quotesfe2/routes.dart';
import 'package:quotesfe2/tools/config.dart';

void main() {

  var browserClient = BrowserClient();

  var config = Config("http://localhost:5050");

var authorService = AuthorService(browserClient, config);
var bookService = BookService(browserClient, config);

final routes = RouteConfiguration(authorService, bookService);

  runApp(MyApp(null, "", routes));
}

class MyApp extends StatelessWidget {

  RouteConfiguration routes;



  MyApp(Key? key, this.initialRoute, this.routes) : super(key: key);
  

  final String initialRoute;
  


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
