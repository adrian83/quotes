import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

class Breadcrumb {
  String _path, _label;
  bool _active, _current;

  Breadcrumb(this._path, this._label, this._active, this._current);

  String get path => this._path;
  String get label => this._label;
  bool get active => this._active;
  bool get current => this._current;
}

@Component(
    selector: 'breadcrumbs',
    templateUrl: 'breadcrumb.template.html',
    directives: const [coreDirectives, routerDirectives])
class Breadcrumbs {
  @Input()
  List<Breadcrumb> elements;
}
