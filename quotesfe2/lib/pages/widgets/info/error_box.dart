import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/common/errors.dart';

class Errors extends StatefulWidget {
  final dynamic error;

  const Errors(Key? key, this.error) : super(key: key);

  @override
  State<Errors> createState() => _ErrorsState();
}

class _ErrorsState extends State<Errors> {
  final TextStyle style =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700);

  @override
  Widget build(BuildContext context) {
    var children =
        widget.error is Exception ? _handleException() : _handleUnknownError();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  List<Widget> _handleUnknownError() {
    return <Widget>[
      Text("UNKNOWN ERROR: ${widget.error} (${widget.error.runtimeType})",
          style: style)
    ];
  }

  List<Widget> _handleException() {
    var ex = widget.error as Exception;
    var widgets = <Widget>[];

    if (ex is ValidationErrors) {
      widgets.add(Text("<< Validation errors >>", style: style));
      for (var valError in ex.validationErrors) {
        widgets.add(Text(valError.message, style: style));
      }
      return widgets;
    }

    return <Widget>[Text("Exception: $ex (${ex.runtimeType})", style: style)];
  }
}
