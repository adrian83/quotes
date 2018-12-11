import 'package:logging/logging.dart';

T log<T>(Logger logger, T next, String message) {
  logger.info(message);
  return next;
}
