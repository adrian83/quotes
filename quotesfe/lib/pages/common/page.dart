import 'package:flutter/material.dart';

import 'package:quotesfe/widgets/common/info_state.dart';

abstract class AbsPage extends StatefulWidget {
  final String _title;

  const AbsPage(Key? key, this._title) : super(key: key);
}

abstract class PageState<T extends AbsPage> extends InfoState<T> {
  List<Widget> renderWidgets(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    children.add(const SizedBox(height: 20));

    children.add(super.build(context));

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
