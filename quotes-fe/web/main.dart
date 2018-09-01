import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:quotes_fe/app_component.template.dart' as ng;
//void main() {
//  runApp(ng.AppComponentNgFactory);
//}




import 'main.template.dart' as self;

@GenerateInjector(
  routerProvidersHash, // You can use routerProviders in production
)
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
