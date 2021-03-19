import 'package:logging/logging.dart';

final Logger logger = Logger('param');

class UrlParams {
  Map<String, String> params = {};

  UrlParams(this.params);

  UrlParams.empty() : this(Map<String, String>());
}

class PathParams {
  Map<String, String> params = {};

  PathParams(List<String> segments, Map<String, int> desc) {
    var entries =
        desc.entries.where((e) => e.value < segments.length).map((e) => MapEntry(e.key, segments[e.value])).toList();
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

    @override
  String toString() => "Params [params: $params]";
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
