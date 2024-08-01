import 'package:flutter/material.dart';

import 'package:quotesfe/pages/common/page.dart';

typedef ToWidgetTransformer<E> = Widget Function(E);

abstract class ShowPage<E> extends AbsPage {
  final ToWidgetTransformer<E> _toWidgetTransformer;

  const ShowPage(super.key, super.title, this._toWidgetTransformer);

  Future<E> findEntity();

  @override
  State<ShowPage<E>> createState() => _ShowPageState();

  List<Widget> additionalWidgets();

  String? createChildButtonLabel();

  String? createChildPath();
}

class _ShowPageState<ENTITY> extends PageState<ShowPage<ENTITY>> {
  ENTITY? _entity;
  List<Widget> _additionalWidgets = [];

  @override
  initState() {
    super.initState();
    widget.findEntity().then((a) {
      setState(() {
        _entity = a;
        _additionalWidgets = widget.additionalWidgets();
      });
    }).catchError((e) {
      showError(e);
    });
  }

  void onBackAction() {
    setState(() {
      _additionalWidgets = widget.additionalWidgets();
    });
  }

  @override
  List<Widget> renderWidgets(BuildContext context) {
    var widgets = <Widget>[];

    widgets.addAll(_additionalWidgets);

    var createChildButtonLabel = widget.createChildButtonLabel();
    var createChildPath = widget.createChildPath();

    if (createChildButtonLabel != null && createChildPath != null) {
      var button = TextButton(
        onPressed: () => Navigator.pushNamed(context, createChildPath).then((value) => onBackAction()),
        child: Text(createChildButtonLabel),
      );
      widgets.add(const SizedBox(height: 20));
      widgets.add(button);
    }

    if(_entity != null){
      widgets.insert(0, widget._toWidgetTransformer(_entity!));
    }

      return widgets;
  }
}
