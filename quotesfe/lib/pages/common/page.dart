import 'package:flutter/material.dart';

import 'package:quotesfe/pages/widgets/info/error_box.dart';
import 'package:quotesfe/pages/widgets/info/info_box.dart';

abstract class AbsPage extends StatefulWidget {
  final String _title;

  const AbsPage(Key? key, this._title) : super(key: key);
}

abstract class PageState<T extends AbsPage> extends State<T> {
  dynamic _error;
  String? _message;

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

  List<Widget> renderWidgets(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (_error != null) {
      children.add(Errors(null, _error!));
    }

    if (_message != null) {
      children.add(Info(null, _message!));
    }

    children.addAll(renderWidgets(context));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        )));
  }
}
