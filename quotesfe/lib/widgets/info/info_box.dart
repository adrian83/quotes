import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  final String info;

  const Info(Key? key, this.info) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final TextStyle style = TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [Text(widget.info, style: style)],
    );
  }
}
