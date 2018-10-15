import 'dart:async';

import 'package:angular/angular.dart';

import 'package:logging/logging.dart';

@Component(
    selector: 'info-messages',
    templateUrl: 'info.template.html',
    directives: const [coreDirectives])
class InfoComponent implements OnInit {
  static final Logger LOGGER = new Logger('InfoComponent');

  @Input()
  List<String> info = ["this is testttt"];

  Future<Null> ngOnInit() async {
    LOGGER.info("InfoComponent initialized. Info: $info");
  }


  void hideInfo(String msg) {
    new Future.delayed(new Duration(milliseconds: 300), () {
      info.removeWhere((i) => i == msg);
    });
  }
}
