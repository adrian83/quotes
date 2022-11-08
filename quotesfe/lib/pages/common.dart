import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'package:quotesfe/domain/common/errors.dart';

typedef ToWidgetTransformer<E> = Widget Function(E);

abstract class ShowEntityPage<ENTITY> extends StatefulWidget {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final ToWidgetTransformer<ENTITY> _toWidgetTransformer;

  final String _title;

  const ShowEntityPage(Key? key, this._title, this._toWidgetTransformer)
      : super(key: key);

  Future<ENTITY> findEntity();

  @override
  State<ShowEntityPage<ENTITY>> createState() => _ShowEntityPageState();
}

class _ShowEntityPageState<ENTITY> extends State<ShowEntityPage<ENTITY>> {
  ENTITY? _entity;
  bool _notFound = false;
  String? errorMsg;

  @override
  initState() {
    developer.log("_ShowEntityPageState initState");
    super.initState();

    widget.findEntity().then((a) {
      setState(() {
        _entity = a;
      });
    }).catchError((ex) {
      setState(() {
        if (ex is NotFoundError) {
          _notFound = true;
        } else if (ex is ValidationErrors) {
          errorMsg = "ValidationErrors";
        } else if (ex is Exception) {
          errorMsg = "Exception";
        } else {
          errorMsg = "WAT!!";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (errorMsg != null) {
      // error
      children = [Text(errorMsg!)];
    } else if (_entity != null) {
      // success
      children = [widget._toWidgetTransformer(_entity!)];
    } else if (_entity == null && !_notFound) {
      // not found
      children = [const Text('waiting...')];
    } else {
      // ??
      children = [const Text('???')];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
