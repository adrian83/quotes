import 'package:logging/logging.dart';

import 'common/form.dart';
import '../common/tuple.dart';


final Logger logger = Logger('param');

class InvalidInputException implements Exception {
  List<Violation> _violation;

  InvalidInputException(this._violation);

  List<Violation> get violation => _violation;
}

class Violation {
  String _field, _message;

  Violation(this._field, this._message);

  String get field => this._field;
  String get message => this._message;

  Map toJson() => {
    "field": _field,
    "message": _message,
  };
}

typedef Transformer<T> = Tuple2<T, Violation> Function(String value, String name, String errorMsg);

class ParamData {
  String _name, _errorMsg;

  ParamData(this._name, this._errorMsg);

  String get name => _name;
  String get errorMsg => _errorMsg;
}

Tuple2<String, Violation> notEmptyString(String value, String name, String errorMsg) {
  if(value == null || value.length == 0){
    var violation = Violation(name, errorMsg);
    return Tuple2<String, Violation>(null, violation);
  }
  return Tuple2<String, Violation>(value, null);
}



class PathParam1<T> {

  PathParams _pathParams;
  Transformer<T> _transformer1;
  ParamData _paramData1;

  PathParam1(this._pathParams, this._transformer1, this._paramData1);

  Tuple2<Tuple1<T>, List<Violation>> validate() {
    var value = this._pathParams.getValue(_paramData1._name);

    logger.info("Value of ${_paramData1._name} is $value");

    var result = this._transformer1(value, _paramData1._name, _paramData1._errorMsg);

    logger.info("Transformation value of ${_paramData1._name} is ${result.e1}");

    var box = Tuple1<T>(result.e1);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    return Tuple2<Tuple1<T>,List<Violation>>(box, violations);
  }

  Tuple1<T> transform() {
    var validationResult = validate();
    if(validationResult.e2.length > 0){
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}

class PathParam2<T1, T2> extends PathParam1<T1> {

  Transformer<T2> _transformer2;
  ParamData _paramData2;

  PathParam2(PathParams pathParams, Transformer<T1> transformer1, ParamData paramData1, 
  this._transformer2, this._paramData2) : super(pathParams, transformer1, paramData1);

  Tuple2<Tuple2<T1, T2>, List<Violation>> validate() {

    Tuple2<Tuple1<T1>, List<Violation>> prev = super.validate();

    var value = this._pathParams.getValue(_paramData2._name);

    var result = this._transformer2(value, this._paramData2._name, this._paramData2._errorMsg);
    List<Violation> violations = result.e2 == null ? [] : [result.e2];

    var nextBox = Tuple2<T1, T2>(prev.e1.e1, result.e1);
    List<Violation> nextViolations = [...prev.e2, ...violations];

    return Tuple2<Tuple2<T1, T2>,List<Violation>>(nextBox, nextViolations);
  }

  Tuple2<T1, T2> transform() {
    var validationResult = validate();
    if(validationResult.e2.length > 0){
      throw InvalidInputException(validationResult.e2);
    }
    return validationResult.e1;
  }
}
