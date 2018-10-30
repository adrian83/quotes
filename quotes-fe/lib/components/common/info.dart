import 'dart:async';

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class Info {
  String _msg, _id;

  Info(this._msg) {
    this._id = Uuid().v4();
  }

  String get msg => _msg;
  String get id => _id;
}

@Component(
    selector: 'info-messages',
    templateUrl: 'info.template.html',
    directives: const [coreDirectives])
class InfoComponent {
  static final Logger LOGGER = new Logger('InfoComponent');

  @Input()
  List<Info> info;

  void hideInfo(Info i) {
    new Future.delayed(new Duration(milliseconds: 300), () {
      info.removeWhere((inf) => i.id == inf.id);
    });
  }
}
