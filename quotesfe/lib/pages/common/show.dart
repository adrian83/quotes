import 'package:flutter/material.dart';

import 'package:quotesfe/pages/common/page.dart';

typedef ToWidgetTransformer<E> = Widget Function(E);

abstract class ShowPage<E> extends AbsPage {
  final ToWidgetTransformer<E> _toWidgetTransformer;

  const ShowPage(Key? key, String title, this._toWidgetTransformer)
      : super(key, title);

  Future<E> findEntity();

  @override
  State<ShowPage<E>> createState() => _ShowPageState();
}

class _ShowPageState<ENTITY> extends PageState<ShowPage<ENTITY>> {
  ENTITY? _entity;

  @override
  initState() {
    super.initState();
    widget.findEntity().then((a) {
      setState(() {
        _entity = a;
      });
    }).catchError((e) {
      showError(e);
    });
  }

  @override
  List<Widget> renderWidgets(BuildContext context) {
    return _entity == null ? [] : [widget._toWidgetTransformer(_entity!)];
  }
}
