import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/common/page.dart' as qpage;
import 'package:quotesfe2/pages/widgets/paging.dart';


typedef PageChangeAction<E> = Future<qpage.Page<E>> Function(qpage.PageRequest);
typedef ToEntryTransformer<A, E> = E Function(A);

typedef OnDeleteAction<E> = Future<void> Function(E);
typedef EditEntityUrl<E> = String Function(E);

class PageEntry<ENTITY, PAGE extends qpage.Page<ENTITY>, ENTRY extends Widget> extends StatefulWidget {
  final String _label;
  final PageChangeAction<ENTITY> _pageChangeAction;
  final ToEntryTransformer<ENTITY, ENTRY> _toEntryTransformer;
  final OnDeleteAction<ENTITY> _onDeleteAction;
  final EditEntityUrl<ENTITY> _editEntityUrl;

  const PageEntry(Key? key, this._label, this._pageChangeAction, this._toEntryTransformer, this._editEntityUrl, this._onDeleteAction) : super(key: key);

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
    developer.log("initializing: ${widget._label}");
    super.initState();
    loadPage(_currentPage);
  }

  void loadPage(int pageNo) {
    developer.log("loading page $pageNo of ${widget._label}");
    _currentPage = pageNo;
      widget
          ._pageChangeAction(qpage.PageRequest.pageWithSize(pageNo, _pageSize))
          .then((page) {
            setState(() {
              _entries = page.elements
                  .map((e) => EntryWrapper<ENTITY>(null, widget._toEntryTransformer(e), e, widget._editEntityUrl, widget._onDeleteAction))
                  .toList(growable: true);
              _pagination = Pagination(widget.key, page.info.pages, pageNo, loadPage);
            });
            if (_entries.isEmpty && pageNo > 0) {
              loadPage(pageNo - 1);
            }
          });
    }

  @override
  Widget build(BuildContext context) {
    developer.log("building: ${widget._label}");
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
    return Text(text, style: Theme.of(context).textTheme.headline4);
  }
}




class EntryWrapper<ENTITY> extends StatefulWidget {

  final Widget _widget;
  final ENTITY _entity;
  final OnDeleteAction<ENTITY> _onDeleteAction;
  final EditEntityUrl<ENTITY> _editEntityUrl;

  const EntryWrapper(Key? key, this._widget, this._entity, this._editEntityUrl, this._onDeleteAction) : super(key: key);

  @override
  State<EntryWrapper<ENTITY>> createState() => _EntryWrapperState<ENTITY>();
}

class _EntryWrapperState<ENTITY> extends State<EntryWrapper<ENTITY>> {

  bool _deleted = false;


  @override
  initState() {
    super.initState();
  }

  void delete() {
    widget._onDeleteAction(widget._entity).then((value){ 
      setState(() {
        _deleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> children = []; 
    if(_deleted){
      children.add(const Text('Deleted'));
    } else {
      children.add(widget._widget);
      children.add(TextButton(
              onPressed: () => Navigator.pushNamed(context,
              '/authors/show/'),
              child: const Text('Delete'))
        );
    }

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
  
}


