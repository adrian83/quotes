import 'package:logging/logging.dart';

import '../../common/tuple.dart';

final Logger logger = Logger('param');

class UrlParams {
  Map<String, String> params = {};

  UrlParams(this.params);

  UrlParams.empty() : this(Map<String, String>());
}

class PathParams {
  Map<String, String> params = {};

  PathParams(List<String> segments, Map<String, int> desc) {
    var entries = desc.entries.where((e) => e.value < segments.length).map((e) => MapEntry(e.key, segments[e.value])).toList();
    params = Map<String, String>.fromEntries(entries);
  }

  PathParams.empty() : this(List.empty(), Map<String, int>());
}

class Params {
  Map<String, String> params = {};

  Params(PathParams path, UrlParams url) {
    params.addAll(url.params);
    params.addAll(path.params);
  }

  Params.empty() : this(PathParams.empty(), UrlParams.empty());

  String? getValue(String name) => params[name];
  int get size => params.length;
}

class InvalidInputException implements Exception {
  List<Violation> violation;

  InvalidInputException(this.violation);
}

class Violation {
  String field, message;

  Violation(this.field, this.message);

  Map toJson() => {
        "field": field,
        "message": message,
      };
}


Tuple2<int, Violation> positiveInteger(String value, String name, String errorMsg) {
  var violation = Violation(name, errorMsg);

  if (value == null || value.length == 0) {
    return Tuple2<int, Violation>(null, violation);
  }

  var intVal = int.parse(value);
  if (intVal < 0) {
    return Tuple2<int, Violation>(null, violation);
  }

  return Tuple2<int, Violation>(intVal, null);
}
