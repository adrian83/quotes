import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'routes.dart';
@Component(
  selector: 'my-app',
  templateUrl: 'app_component.template.html',
  directives: const [routerDirectives],
  exports: [RoutePaths, Routes],
)

class AppComponent {
  var name = 'Angular';
}
