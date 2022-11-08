import 'package:flutter/material.dart';
import 'package:quotesfe/pages/common/page.dart';

typedef ToWidgetTransformer<E> = Widget Function(E);

abstract class ShowPage<ENTITY> extends AbsPage {
  final ToWidgetTransformer<ENTITY> _toWidgetTransformer;

  const ShowPage(Key? key, String title, this._toWidgetTransformer)
      : super(key, title);

  Future<ENTITY> findEntity();

  @override
  State<ShowPage<ENTITY>> createState() => _ShowPageState();
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
    return [widget._toWidgetTransformer(_entity!)];
  }
}
