import 'package:flutter/material.dart';
import 'package:quotesfe/pages/widgets/info/error_box.dart';
import 'package:quotesfe/pages/widgets/info/info_box.dart';

abstract class AbsPage extends StatefulWidget {
  final String title;

  const AbsPage(Key? key, this.title) : super(key: key);
}

abstract class PageState<T extends AbsPage> extends State<T> {
  dynamic error;
  String? message;

  void showError(dynamic e) {
    setState(() {
      error = e;
    });
  }

  void showInfo(String i) {
    setState(() {
      message = i;
    });
  }

  bool isError() => error != null;

  bool isMessage() => message != null;

  List<Widget> renderWidgets(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (error != null) {
      children.add(Errors(null, error!));
    }

    if (message != null) {
      children.add(Info(null, message!));
    }

    children.addAll(renderWidgets(context));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ));
  }
}
