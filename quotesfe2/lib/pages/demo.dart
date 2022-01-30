
import 'dart:io' show Platform;

import 'package:flutter/material.dart';


const _demoViewedCountKey = 'demoViewedCountKey';

enum _DemoState {
  normal,
  options,
  info,
  code,
  fullscreen,
}

class DemoPage extends StatefulWidget {

  const DemoPage({Key? key}) : super(key: key);

  static const String baseRoute = '/demo';

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

      // Return to root if invalid slug.
      //Navigator.of(context).pop();

    return ScaffoldMessenger(child: Text("Demo"));
  }
}

