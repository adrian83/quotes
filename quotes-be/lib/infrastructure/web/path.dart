import 'package:quotes/common/tuple.dart';

import './param.dart';
import './exception.dart';

bool empty(String? s) => s == null || s.trim().length == 0;
bool notEmpty(String? s) => !empty(s);

class Param<T> {
  String name;
  T? value;

  Param(this.name, this.value);
}

class PathParameter1<T> {
  Param<T> param1;

  PathParameter1(this.param1);
}

class PathParameter2<T1, T2> extends PathParameter1<T1> {
  Param<T2> param2;

  PathParameter2(Param<T1> param1, this.param2) : super(param1);
}

class PathParameter3<T1, T2, T3> extends PathParameter2<T1, T2> {
  Param<T3> param3;

  PathParameter3(Param<T1> param1, Param<T2> param2, this.param3) : super(param1, param2);
}

PathParameter1<String> createPathParameter1(Params params, String name) {
  String? value = params.getValue(name);

  if (notEmpty(value)) {
    var param = Param(name, value);
    return PathParameter1(param);
  }

  var violation = Violation(name, "invalid parameter");
  throw InvalidPathParameterException([violation]);
}

PathParameter2<String, String> createPathParameter2(Params params, String name1, String name2) {
  var p = createPathParameter1(params, name1);

  String? value = params.getValue(name2);

  if (notEmpty(value)) {
    var param2 = Param(name2, value);
    return PathParameter2(p.param1, param2);
  }

  var violation = Violation(name2, "invalid parameter");
  throw InvalidPathParameterException([violation]);
}

PathParameter3<String, String, String> createPathParameter3(Params params, String name1, String name2, String name3) {
  var p = createPathParameter2(params, name1, name2);

  String? value = params.getValue(name2);

  if (notEmpty(value)) {
    var param3 = Param(name3, value);
    return PathParameter3(p.param1, p.param2, param3);
  }

  var violation = Violation(name3, "invalid parameter");
  throw InvalidPathParameterException([violation]);
}

PathParameter3<String, int, int> createSearchParams(Params params, String name1, String name2, String name3) {
  String? value1 = params.getValue(name1);
  String? value2 = params.getValue(name2);
  String? value3 = params.getValue(name3);

  var param1 = Param(name1, value1);
  var param2Tuple = parseIntParam(name2, value2);
  var param3Tuple = parseIntParam(name3, value3);

  List<Violation> violations = List<Violation>.from([param2Tuple.e2, param3Tuple.e2].where((v) => v != null).toList());

  if (violations.isNotEmpty) {
    throw InvalidPathParameterException(violations);
  }

  return PathParameter3(param1, Param(name2, param2Tuple.e1), Param(name3, param3Tuple.e1));
}

Tuple2<int, Violation> parseIntParam(String name, String? strValue) {
  if (empty(strValue)) {
    return Tuple2(null, Violation(name, "empty parameter"));
  }

  try {
    return Tuple2(int.parse(strValue ?? ""), null);
  } catch (e) {
    return Tuple2(null, Violation(name, "invalid parameter"));
  }
}
