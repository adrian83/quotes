import '../../domain/common/errors.dart';

import 'package:logging/logging.dart';
import './info.dart';

class ErrorHandler {
  static final Logger LOGGER = new Logger('ErrorHandler');

  List<ValidationError> _validationErrors;
  ServerError _serverError;
  List<Info> _info = new List<Info>();

  void handleError(e) {
    LOGGER.info("Handle error: $e");
    if (e is ValidationErrors) {
      cleanValidationErrors();
      this.validationErrors = e.validationErrors;
      LOGGER.info("Validation errors: $validationErrors");
      return;
    } else if (e is ServerError) {
      this._serverError = e;
      LOGGER.info("Server error: $_serverError");
      return;
    } else if (e is NotFoundError) {
      this._serverError = ServerError("not found");
      LOGGER.info("Not Found error: $_serverError");
      return;
    }


    LOGGER.info("Errors: $e");
  }

  void set validationErrors(List<ValidationError> errors){
    this._validationErrors = errors;
  }

  List<ValidationError> get validationErrors => this._validationErrors == null
      ? new List<ValidationError>()
      : this._validationErrors;

  ServerError get serverError => _serverError;

  void cleanValidationErrors(){
    this._validationErrors = new List<ValidationError>();
  }

  List<Info> get info => _info;

  void showInfo(String msg) {
    LOGGER.info("show info: $msg");
    _info.add(Info(msg));
  }

}
