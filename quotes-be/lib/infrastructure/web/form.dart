import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'param.dart';
import '../../common/tuple.dart';

abstract class FormParser<T> {
  Tuple2<T, List<Violation>> parse(Map rawForm);
}

bool exists(Object? o) => o != null;
bool isString(Object? o) => exists(o) && o is String;
bool empty(String? str) => str == null || str.length == 0;
bool shorter(String str, int limit) => str.length < limit;
bool longer(String str, int limit) => str.length > limit;

Future<Map> readForm<F>(HttpRequest req) => req
    .toList()
    .then((lol) => lol.map((l) => String.fromCharCodes(l)))
    .then((los) => los.join())
    .then((content) => jsonDecode(content) as Map);
