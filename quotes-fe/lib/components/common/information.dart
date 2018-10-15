import 'dart:async';

import 'package:angular/angular.dart';

import 'package:logging/logging.dart';

import '../../domain/common/errors.dart';

@Component(
    selector: 'info-messages',
    templateUrl: 'info.template.html',
    directives: const [coreDirectives])
class InformationComponent implements OnInit {
  static final Logger LOGGER = new Logger('InformationComponent');

  @Input()
  List<String> info = ["this is test"];

  @Input()
  ServerError error;

  @Input()
  List<ValidationError> errors;

  Future<Null> ngOnInit() async {
    LOGGER.info("InformationComponent initialized. Info: $info, Error: $error");
  }

  ServerError get serverError => error;

  void hideInfo(String msg) {
    new Future.delayed(new Duration(milliseconds: 300), () {
      info.removeWhere((i) => i == msg);
    });
  }

  void hideError() {
    new Future.delayed(new Duration(milliseconds: 300), () {
      error = null;
    });
  }

  void hideValidationError(ValidationError err) {
    new Future.delayed(new Duration(milliseconds: 300), () {
      errors.removeWhere((e) => e.message == err.message);
    });
  }
}
