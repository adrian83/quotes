
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quotesfe2/deferred_widget.dart';
import 'package:quotesfe2/main.dart';
import 'package:quotesfe2/pages/demo.dart';
import 'package:quotesfe2/pages/home.dart';


typedef PathWidgetBuilder = Widget Function(BuildContext, String);

class Path {
  const Path(this.pattern, this.builder);

  final String pattern;
  final PathWidgetBuilder builder;
}

class RouteConfiguration {
  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<Path> paths = [
    Path(
      r'^' + DemoPage.baseRoute + r'/([\w-]+)$',
      (context, match) => DemoPage(),
    ),
    Path(
      r'^/',
      (context, match) => const HomePage(null, "Home"),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print("onGenerateRoute");
    for (final path in paths) {
      final regExpPattern = RegExp(path.pattern);
      var name = settings.name;
      print("name $name");
      if(name == null) {
          return NoAnimationMaterialPageRoute<void>(
            (context) => path.builder(context, "test-match"),
            settings,
          );
          
      }
      if (regExpPattern.hasMatch(name)) {
        final firstMatch = regExpPattern.firstMatch(name);

        final match = (firstMatch?.groupCount == 1) ? firstMatch?.group(1) : null;
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
    @required WidgetBuilder builder,
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
