import 'package:flutter/material.dart';

typedef SelectPageAction = Function(int);

const maxPagesOnLeft = 2;
const maxPagesOnRight = 2;

class Pagination extends StatefulWidget {
  final int _pages, current;
  final SelectPageAction _selectPageAction;

  const Pagination(Key? key, this._pages, this.current, this._selectPageAction) : super(key: key);

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
    var canceledOnLeftDiff = current - maxPagesOnLeft;
    var canceledOnLeft = canceledOnLeftDiff < 0 ? canceledOnLeftDiff * -1 : 0;

    var canceledOnRightDiff = widget._pages - (current + 1);
    var canceledOnRight = canceledOnRightDiff >= maxPagesOnRight ? 0 : maxPagesOnRight - canceledOnRightDiff;

    var toLeft = maxPagesOnLeft + canceledOnRight;
    var toRight = maxPagesOnRight + canceledOnLeft;

    var startWithDots = false;
    var endsWithDots = false;

    var links = <TextButton>[];

    for (var i = 0; i < widget._pages; i += 1) {
      if (i < current - toLeft) {
        startWithDots = true;
        continue;
      }

      if (i > (current + toRight)) {
        endsWithDots = true;
        continue;
      }

      links.add(generateButton(i, "${i + 1}", i != current));
    }

    if (links.isNotEmpty) {
      var isFirst = current == 0;
      var isLast = current >= (widget._pages - 1);

      links.insert(0, generateButton(0, "<<", !isFirst));
      links.insert(1, generateButton(current - 1, "<", !isFirst));

      if (startWithDots) {
        links.insert(2, generateButton(0, "...", false));
      }

      if (endsWithDots) {
        links.add(generateButton(0, "...", false));
      }

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
