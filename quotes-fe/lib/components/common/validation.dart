import 'dart:async';

import 'package:angular/angular.dart';

import 'package:logging/logging.dart';

import '../../domain/common/errors.dart';

@Component(
    selector: 'validation-errors',
    templateUrl: 'validation.template.html',
    directives: const [coreDirectives])
class ValidationErrorsComponent implements OnInit {
  static final Logger LOGGER = new Logger('ValidationErrorsComponent');

  @Input()
  List<ValidationError> errors;

  Future<Null> ngOnInit() async {
    LOGGER.info("ValidationErrors initialized. Errors: $errors");
  }

  void hideError(ValidationError err) {
    new Future.delayed(new Duration(milliseconds: 300), () {
      errors.removeWhere((e) => e.message == err.message);
    });
  }

}
