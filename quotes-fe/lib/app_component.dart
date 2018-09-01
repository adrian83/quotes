import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:http/browser_client.dart';

import 'routes.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.template.html',
  directives: const [routerDirectives],
  exports: [RoutePaths, Routes],
  providers: [ClassProvider(BrowserClient)],
)

class AppComponent {
  var name = 'Angular';
}
