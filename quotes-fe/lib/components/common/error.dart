import 'dart:async';

import 'package:angular/angular.dart';

import 'package:logging/logging.dart';

import '../../common/errors.dart';


@Component(
    selector: 'server-errors',
    templateUrl: 'error.template.html',
    directives: const [coreDirectives])
class ServerErrorsComponent implements OnInit {
  static final Logger LOGGER = new Logger('ServerErrorsComponent');

  @Input()
  ServerError error;

  Future<Null> ngOnInit() async {
    LOGGER.info("ServerErrorsComponent initialized. Error: $error");
  }

  ServerError get serverError => error;

  void hideError() {
    new Future.delayed(new Duration(milliseconds: 300), () {
      error = null;
    });
  }
}
