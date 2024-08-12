import 'package:flutter/material.dart';

import 'package:quotes_frontend/widgets/page_entry.dart';
import 'package:quotes_frontend/widgets/info/error_box.dart';
import 'package:quotes_frontend/widgets/info/info_box.dart';

abstract class InfoState<T extends StatefulWidget> extends State<T> {
  dynamic _error;
  String? _message;

  String? get message => _message;
  dynamic get error => _error;

  void showError(dynamic e) {
    setState(() {
      _error = e;
    });
  }

  void showInfo(String i) {
    setState(() {
      _message = i;
    });
  }

  bool isError() => _error != null;

  bool isMessage() => _message != null;

  ErrorHandler errorHandler() => (dynamic o) => showError(o);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (_error != null) {
      children.add(Errors(null, _error!));
    }

    if (_message != null) {
      children.add(Info(null, _message!));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
