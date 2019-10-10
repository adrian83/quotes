import 'package:logging/logging.dart';

import '../../common/tuple.dart';

final Logger logger = Logger('param');

class UrlParams {
  Map<String, String> params = {};

  UrlParams(this.params);
}

class PathParams {
  Map<String, String> params = {};

  PathParams(List<String> segments, Map<String, int> desc) {
    var entries = desc.entries.where((e) => e.value < segments.length).map((e) => MapEntry(e.key, segments[e.value])).toList();
    params = Map<String, String>.fromEntries(entries);
  }
}

class Params {
  Map<String, String> params = {};

  Params(PathParams path, UrlParams url) {
    if (url != null) params.addAll(url.params);
    if (path != null) params.addAll(path.params);
  }

  Params.empty() : this(null, null);

  String getValue(String name) => params[name];
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

typedef Transformer<T> = Tuple2<T, Violation> Function(String value, String name, String errorMsg);

class ParamData {
  String name, errorMsg;

  ParamData(this.name, this.errorMsg);
}

Tuple2<String, Violation> notEmptyString(String value, String name, String errorMsg) {
  if (value == null || value.length == 0) {
    var violation = Violation(name, errorMsg);
    return Tuple2<String, Violation>(null, violation);
  }
  return Tuple2<String, Violation>(value, null);
}

Tuple2<String, Violation> optionalString(String value, String name, String errorMsg) {
  if (value == null || value.length == 0) {
    return Tuple2<String, Violation>(null, null);
  }
  return Tuple2<String, Violation>(value, null);
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

class PathParam1<T> {
  Params _params;
  Transformer<T> _transformer1;
  ParamData _paramData1;

  PathParam1(this._params, this._transformer1, this._paramData1);

  Tuple2<Tuple1<T>, List<Violation>> validate() {
    var value = this._params.getValue(_paramData1.name);

    logger.info("Value of ${_paramData1.name} is $value");

    var result = this._transformer1(value, _paramData1.name, _paramData1.errorMsg);

    logger.info("Transformation value of ${_paramData1.name} is ${result.e1}");

    var box = Tuple1<T>(result.e1);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    return Tuple2<Tuple1<T>, List<Violation>>(box, violations);
  }

  Tuple1<T> transform() {
    var validationResult = validate();
    if (validationResult.e2.length > 0) {
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}

class PathParam2<T1, T2> extends PathParam1<T1> {
  Transformer<T2> _transformer2;
  ParamData _paramData2;

  PathParam2(Params params, Transformer<T1> transformer1, ParamData paramData1, this._transformer2, this._paramData2) : super(params, transformer1, paramData1);

  Tuple2<Tuple2<T1, T2>, List<Violation>> validate() {
    Tuple2<Tuple1<T1>, List<Violation>> prev = super.validate();

    var value = this._params.getValue(_paramData2.name);

    var result = this._transformer2(value, this._paramData2.name, this._paramData2.errorMsg);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    var nextBox = Tuple2<T1, T2>(prev.e1.e1, result.e1);
    List<Violation> nextViolations = [...prev.e2, ...violations];

    return Tuple2<Tuple2<T1, T2>, List<Violation>>(nextBox, nextViolations);
  }

  Tuple2<T1, T2> transform() {
    var validationResult = validate();
    if (validationResult.e2.length > 0) {
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}

class PathParam3<T1, T2, T3> extends PathParam2<T1, T2> {
  Transformer<T3> _transformer3;
  ParamData _paramData3;

  PathParam3(Params params, Transformer<T1> transformer1, ParamData paramData1, Transformer<T2> transformer2, ParamData paramData2, this._transformer3,
      this._paramData3)
      : super(params, transformer1, paramData1, transformer2, paramData2);

  Tuple2<Tuple3<T1, T2, T3>, List<Violation>> validate() {
    Tuple2<Tuple2<T1, T2>, List<Violation>> prev = super.validate();

    var value = this._params.getValue(_paramData3.name);

    var result = this._transformer3(value, this._paramData3.name, this._paramData3.errorMsg);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    var nextBox = Tuple3<T1, T2, T3>(prev.e1.e1, prev.e1.e2, result.e1);
    List<Violation> nextViolations = [...prev.e2, ...violations];

    return Tuple2<Tuple3<T1, T2, T3>, List<Violation>>(nextBox, nextViolations);
  }

  Tuple3<T1, T2, T3> transform() {
    var validationResult = validate();
    if (validationResult.e2.length > 0) {
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}

class PathParam4<T1, T2, T3, T4> extends PathParam3<T1, T2, T3> {
  Transformer<T4> _transformer4;
  ParamData _paramData4;

  PathParam4(Params params, Transformer<T1> transformer1, ParamData paramData1, Transformer<T2> transformer2, ParamData paramData2,
      Transformer<T3> transformer3, ParamData paramData3, this._transformer4, this._paramData4)
      : super(params, transformer1, paramData1, transformer2, paramData2, transformer3, paramData3);

  Tuple2<Tuple4<T1, T2, T3, T4>, List<Violation>> validate() {
    Tuple2<Tuple3<T1, T2, T3>, List<Violation>> prev = super.validate();

    var value = this._params.getValue(_paramData4.name);

    var result = this._transformer4(value, this._paramData4.name, this._paramData4.errorMsg);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    var nextBox = Tuple4<T1, T2, T3, T4>(prev.e1.e1, prev.e1.e2, prev.e1.e3, result.e1);
    List<Violation> nextViolations = [...prev.e2, ...violations];

    return Tuple2<Tuple4<T1, T2, T3, T4>, List<Violation>>(nextBox, nextViolations);
  }

  Tuple4<T1, T2, T3, T4> transform() {
    var validationResult = validate();
    if (validationResult.e2.length > 0) {
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}

class PathParam5<T1, T2, T3, T4, T5> extends PathParam4<T1, T2, T3, T4> {
  Transformer<T5> _transformer5;
  ParamData _paramData5;

  PathParam5(Params params, Transformer<T1> transformer1, ParamData paramData1, Transformer<T2> transformer2, ParamData paramData2,
      Transformer<T3> transformer3, ParamData paramData3, Transformer<T4> transformer4, ParamData paramData4, this._transformer5, this._paramData5)
      : super(params, transformer1, paramData1, transformer2, paramData2, transformer3, paramData3, transformer4, paramData4);

  Tuple2<Tuple5<T1, T2, T3, T4, T5>, List<Violation>> validate() {
    Tuple2<Tuple4<T1, T2, T3, T4>, List<Violation>> prev = super.validate();

    var value = this._params.getValue(_paramData5.name);

    var result = this._transformer5(value, this._paramData5.name, this._paramData5.errorMsg);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    var nextBox = Tuple5<T1, T2, T3, T4, T5>(prev.e1.e1, prev.e1.e2, prev.e1.e3, prev.e1.e4, result.e1);
    List<Violation> nextViolations = [...prev.e2, ...violations];

    return Tuple2<Tuple5<T1, T2, T3, T4, T5>, List<Violation>>(nextBox, nextViolations);
  }

  Tuple5<T1, T2, T3, T4, T5> transform() {
    var validationResult = validate();
    if (validationResult.e2.length > 0) {
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}
