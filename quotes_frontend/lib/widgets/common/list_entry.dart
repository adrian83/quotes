import 'package:flutter/material.dart';

typedef OnBackAction = Function();

abstract class ListEntry extends StatefulWidget {
  final String _label;
  final bool _showId, _showLabel;
  final OnBackAction? _onBackAction;

  const ListEntry(Key? key, this._label, this._showLabel, this._showId, this._onBackAction) : super(key: key);

  @override
  State<ListEntry> createState() => _ListEntryState();

  String getId();

  List<Widget> widgets(BuildContext context);

  String updatePageUrl();
  String deletePageUrl();
  String eventsPageUrl();

  Function onBackAction() => () {
        if (_onBackAction != null) _onBackAction!();
      };

  Padding paddingWithText(String text) => paddingWithWidget(Text(text));

  Padding paddingWithWidget(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: widget,
    );
  }
}

class _ListEntryState extends State<ListEntry> {
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (widget._showLabel) {
      children.add(Text(widget._label, style: Theme.of(context).textTheme.headlineMedium));
    }

    if (widget._showId) {
      children.add(widget.paddingWithText('Id: ${widget.getId()}'));
    }

    children.addAll(widget.widgets(context));

    var buttons = Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      TextButton(
        onPressed: gotoUpdatePage(context),
        child: const Text('Update'),
      ),
      TextButton(
        onPressed: gotoDeletePage(context),
        child: const Text('Delete'),
      ),
      TextButton(
        onPressed: gotoEventsPage(context),
        child: const Text('Events'),
      )
    ]);

    children.add(widget.paddingWithWidget(buttons));

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ));
  }

  Function()? gotoUpdatePage(BuildContext context) => () => Navigator.pushNamed(context, widget.updatePageUrl()).then((value) => widget.onBackAction()());

  Function()? gotoDeletePage(BuildContext context) => () => Navigator.pushNamed(context, widget.deletePageUrl()).then((value) => widget.onBackAction()());

  Function()? gotoEventsPage(BuildContext context) => () => Navigator.pushNamed(context, widget.eventsPageUrl()).then((value) => widget.onBackAction()());
}
