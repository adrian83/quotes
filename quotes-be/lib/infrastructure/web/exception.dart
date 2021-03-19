import './param.dart';

class InvalidPathParameterException implements Exception {
  List<Violation> violations;

  InvalidPathParameterException(this.violations);
}
