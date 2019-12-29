import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:http/browser_client.dart';

import 'package:logging/logging.dart';

import 'routes.dart';

import 'tools/config.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.template.html',
  directives: [coreDirectives, routerDirectives],
  exports: [RoutePaths, Routes],
  providers: [ClassProvider(BrowserClient), ClassProvider(Config)],
)
class AppComponent {
  AppComponent() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }
}
