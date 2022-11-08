import 'package:flutter/material.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/pages/common/page.dart';
import 'package:quotesfe/pages/widgets/paging.dart';
import 'package:quotesfe/domain/common/page.dart' as p;

abstract class ListEventsPage<T> extends AbsPage {
  const ListEventsPage(Key? key, String title) : super(key, title);

  @override
  State<ListEventsPage<T>> createState() => _ListEventsPageState<T>();

  Future<p.Page<T>> getPage(PageRequest pageReq);

  List<Widget> eventToData(T event);

  List<String> columns();
}

class _ListEventsPageState<T> extends PageState<ListEventsPage<T>> {
  p.Page<T>? page;
  Pagination _pagination = Pagination.empty(null);
  int _currentPage = 0;
  final int _pageSize = 2;

  @override
  initState() {
    super.initState();
    loadPage(_currentPage);
  }

  void loadPage(int pageNo) {
    _currentPage = pageNo;
    var pageReq = PageRequest.pageWithSize(pageNo, _pageSize);
    widget.getPage(pageReq).then((p) {
      setState(() {
        page = p;
        _pagination =
            Pagination(widget.key, page!.info.pages, pageNo, loadPage);
      });
      if (page!.elements.isEmpty && pageNo > 0) {
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
    var cells =
        widget.eventToData(event).map((value) => DataCell(value)).toList();
    return DataRow(cells: cells);
  }

  List<DataRow> rows() =>
      page == null ? [] : page!.elements.map((e) => generateRow(e)).toList();
}
