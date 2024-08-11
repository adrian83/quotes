import 'package:flutter/material.dart';

import 'package:quotesfe/pages/common/page.dart';
import 'package:quotesfe/widgets/paging.dart';
import 'package:quotes_common/domain/page.dart' as pg;
import 'package:quotes_common/domain/entity.dart';

abstract class ListEventsPage<T extends Entity> extends AbsPage {
  const ListEventsPage(super.key, super.title);

  @override
  State<ListEventsPage<T>> createState() => _ListEventsPageState<T>();

  Future<pg.Page<T>> getPage(pg.PageRequest pageReq);

  List<Widget> eventToData(T event);

  List<String> columns();
}

class _ListEventsPageState<T extends Entity> extends PageState<ListEventsPage<T>> {
  final int _pageSize = 2;
  pg.Page<T> _page = pg.Page.empty();
  Pagination _pagination = Pagination.empty(null);
  int _currentPage = 0;

  @override
  initState() {
    super.initState();
    loadPage(_currentPage);
  }

  void loadPage(int pageNo) {
    _currentPage = pageNo;
    var pageReq = pg.PageRequest.pageWithSize(pageNo, _pageSize);
    widget.getPage(pageReq).then((p) {
      setState(() {
        _page = p;
        _pagination = Pagination(widget.key, _page.info.pages, pageNo, loadPage);
      });
      if (_page.elements.isEmpty && pageNo > 0) {
        loadPage(pageNo - 1);
      }
    }).catchError((e) {
      showError(e);
    });
  }

  @override
  List<Widget> renderWidgets(BuildContext context) {
    var columns = widget.columns().map((name) => columnName(name)).toList();

    var table = DataTable(
      columns: columns,
      rows: rows(),
    );

    return [table, const SizedBox(height: 10), _pagination];
  }

  DataColumn columnName(String name) {
    return DataColumn(
      label: Expanded(
        child: Text(
          name,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  DataRow generateRow(T event) {
    var cells = widget.eventToData(event).map((value) => DataCell(value)).toList();
    return DataRow(cells: cells);
  }

  List<DataRow> rows() => _page.elements.map((e) => generateRow(e)).toList();
}
