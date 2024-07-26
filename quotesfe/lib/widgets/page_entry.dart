import 'package:flutter/material.dart';

import 'package:quotesfe/domain/common/page.dart' as qpage;
import 'package:quotesfe/widgets/paging.dart';

typedef PageChangeAction<E> = Future<qpage.Page<E>> Function(qpage.PageRequest);
typedef ToEntryTransformer<A, E> = E Function(A);

typedef OnDeleteAction<E> = Future<void> Function(E);
typedef EditEntityUrl<E> = String Function(E);

typedef ErrorHandler = Function(Object);

class PageEntry<ENTITY, PAGE extends qpage.Page<ENTITY>, ENTRY extends Widget> extends StatefulWidget {
  final String _label;
  final PageChangeAction<ENTITY> _pageChangeAction;
  final ToEntryTransformer<ENTITY, ENTRY> _toEntryTransformer;
  final ErrorHandler _errorHandler;

  const PageEntry(Key? key, this._label, this._pageChangeAction, this._toEntryTransformer, this._errorHandler) : super(key: key);

  @override
  State<PageEntry<ENTITY, PAGE, ENTRY>> createState() => _PageEntryState<ENTITY, PAGE, ENTRY>();
}

class _PageEntryState<ENTITY, PAGE extends qpage.Page<ENTITY>, ENTRY extends Widget> extends State<PageEntry<ENTITY, PAGE, ENTRY>> {
  final int _pageSize = 2;

  Pagination _pagination = Pagination.empty(null);
  List<Widget> _entries = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadPage(_currentPage);
  }

  void loadPage(int pageNo) {
    _currentPage = pageNo;
    widget._pageChangeAction(qpage.PageRequest.pageWithSize(pageNo, _pageSize)).then((page) {
      setState(() {
        _entries = page.elements.map((e) => widget._toEntryTransformer(e)).toList(growable: true);
        _pagination = Pagination(widget.key, page.info.pages, pageNo, loadPage);
      });
      if (_entries.isEmpty && pageNo > 0) {
        loadPage(pageNo - 1);
      }
    }).catchError(widget._errorHandler);
  }

  @override
  Widget build(BuildContext context) {
    var widgets = _entries.isEmpty
        ? [_searchEntityHeader(widget._label), const Text("Empty...")]
        : [
            _searchEntityHeader(widget._label),
            ..._entries,
            _pagination,
          ];

    return Column(
      key: null,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  Text _searchEntityHeader(String text) {
    return Text(text, style: Theme.of(context).textTheme.headlineMedium);
  }
}
