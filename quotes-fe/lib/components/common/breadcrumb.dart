import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

class Breadcrumb {
  String _path, _label;
  bool _active, _current;

  Breadcrumb(this._path, String label, this._active, this._current) {
    this._label = label == null ? "-" : label.toLowerCase();
  }

  Breadcrumb.link(String path, String label) : this(path, label, true, false);

  Breadcrumb.text(String label) : this("", label, false, false);

  Breadcrumb last() {
    _current = true;
    return this;
  }

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
