import 'package:flutter/material.dart';

import 'package:quotesfe2/routes.dart';

void main() {
  runApp(const MyApp(null, ""));
}

class MyApp extends StatelessWidget {
  const MyApp(Key? key, this.initialRoute) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior(),
      restorationScopeId: 'rootQuotes',
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}
