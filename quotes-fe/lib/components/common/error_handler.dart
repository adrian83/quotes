import 'package:logging/logging.dart';

import '../../domain/common/errors.dart';
import '../../domain/common/event.dart';

class ErrorHandler {
  static final Logger logger = Logger('ErrorHandler');

  List<Event> _events = [];

  List<Event> get events => _events;

  void handleError(Object e) {
    logger.info("Handle error: $e");
    if (e is ValidationErrors) {
      _events.add(InvalidDataEvent(e.validationErrors));
      logger.info("Validation errors: $events");
      return;
    } else if (e is NotFoundError) {
      _events.add(ErrorEvent("Not found"));
      return;
    } else if (e is Exception) {
      _events.add(ErrorEvent("Error: ${e.toString()}"));
      return;
    } else {
      _events.add(ErrorEvent("Error: ${e.toString()}"));
      logger.info("Error type: ${e.runtimeType}");
    }

    logger.info("Errors: $e");
  }

  void showInfo(String msg) {
    logger.info("show info: $msg");
    _events.add(InfoEvent(msg));
  }
}
