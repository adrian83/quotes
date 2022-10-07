import 'package:flutter/material.dart';

typedef SelectPageAction = Function(int);

class Pagination extends StatefulWidget {
  final int _pages, current;
  final SelectPageAction _selectPageAction;

  const Pagination(Key? key, this._pages, this.current, this._selectPageAction)
      : super(key: key);

  Pagination.empty(Key? key) : this(key, 0, 0, (i) => "");

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late int current;
  @override
  initState() {
    super.initState();
    current = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    var links = [for (var i = 0; i < widget._pages; i += 1) i]
        .map((i) => generateButton(i, "${i + 1}", i != current))
        .toList();

    if (links.isNotEmpty) {
      var isFirst = current == 0;
      var isLast = current >= (widget._pages - 1);

      links.insert(0, generateButton(0, "<<", !isFirst));
      links.insert(1, generateButton(current - 1, "<", !isFirst));

      links.add(generateButton(current + 1, ">", !isLast));
      links.add(generateButton(widget._pages - 1, ">>", !isLast));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[...links],
    );
  }

  changePage(int i) {
    setState(() {
      current = i;
      widget._selectPageAction(i);
    });
  }

  TextButton generateButton(int i, String label, bool enabled) {
    var action = enabled ? () => changePage(i) : null;

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: action,
      child: Text(label),
    );
  }
}
