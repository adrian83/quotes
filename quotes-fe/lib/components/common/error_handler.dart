import 'package:logging/logging.dart';

import '../../domain/common/errors.dart';
import '../../domain/common/event.dart';



class ErrorHandler {
  static final Logger LOGGER = new Logger('ErrorHandler');

  List<Event> _events = [];

  List<Event> get events => _events;

  void handleError(Object e) {
    LOGGER.info("Handle error: $e");
    if (e is ValidationErrors) {
      _events.add(InvalidDataEvent(e.validationErrors));
      LOGGER.info("Validation errors: $events");
      return;
    } else if (e is NotFoundError) {
      _events.add(ErrorEvent("Not found"));
      return;
    } else if (e is Exception) {
      _events.add(ErrorEvent("Error: ${e.toString()}"));
      return;
    } else {
      _events.add(ErrorEvent("Error: ${e.toString()}"));
      LOGGER.info("Error type: ${e.runtimeType}");
    }

    LOGGER.info("Errors: $e");
  }


  void showInfo(String msg) {
    LOGGER.info("show info: $msg");
    _events.add(InfoEvent(msg));
  }

}
