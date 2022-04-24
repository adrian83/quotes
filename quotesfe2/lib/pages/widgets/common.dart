import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/common/page.dart' as qpage;
import 'package:quotesfe2/pages/widgets/paging.dart';


typedef PageChangeAction<E> = Future<qpage.Page<E>> Function(qpage.PageRequest);
typedef ToEntryTransformer<A, E> = E Function(A);

class PageEntry<ENTITY, PAGE extends qpage.Page<ENTITY>, ENTRY extends Widget> extends StatefulWidget {
  final String _label;
  final PageChangeAction<ENTITY> _pageChangeAction;
  final ToEntryTransformer<ENTITY, ENTRY> _toEntryTransformer;

  const PageEntry(Key? key, this._label, this._pageChangeAction, this._toEntryTransformer) : super(key: key);

  @override
  State<PageEntry<ENTITY, PAGE, ENTRY>> createState() => _PageEntryState<ENTITY, PAGE, ENTRY>();
}

class _PageEntryState<ENTITY, PAGE extends qpage.Page<ENTITY>, ENTRY extends Widget> extends State<PageEntry<ENTITY, PAGE, ENTRY>> {
  Pagination _pagination = Pagination.empty(null);
  List<ENTRY> _entries = [];

  @override
  initState() {
    print("${widget._label} initState");
    super.initState();
    loadPage(_defaultPage);
  }

  final int _pageSize = 2;
  final int _defaultPage = 0;

  loadPage(int pageNo) {
    print("${widget._label} loadPage");
    
      widget
          ._pageChangeAction(qpage.PageRequest(_pageSize, pageNo))
          .then((page) {
            print("page: ${page.first}");
            setState(() {
              _entries = page.elements
                  .map((e) => widget._toEntryTransformer(e))
                  .toList(growable: true);
              _pagination = Pagination(widget.key, page.info.pages, pageNo, loadPage);
            }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${widget._label} build");
    return Column(
      key: null,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _searchEntityHeader(widget._label),
        ..._entries,
        _pagination,
      ],
    );
  }

  Text _searchEntityHeader(String text) {
    print("_searchEntityHeader $text");
    return Text(text, style: Theme.of(context).textTheme.headline4);
  }
}
