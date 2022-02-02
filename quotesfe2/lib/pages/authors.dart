import 'package:flutter/material.dart';



class NewAuthorPage extends StatefulWidget {

  static String routePattern = r'^/authors/new/?(&[\w-=]+)?$';

  final String title;

  const NewAuthorPage(Key? key, this.title) : super(key: key);

  @override
  State<NewAuthorPage> createState() => _NewAuthorPageState();
}

class _NewAuthorPageState extends State<NewAuthorPage> {

  void _persist() {
    setState(() {
      print("save author");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('???'),
            Text('test', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _persist,
        tooltip: 'Save',
        child: const Icon(Icons.add),
      ),
    );
  }
}



class ShowAuthorPage extends StatefulWidget {

  static String routePattern = r'^/authors/show/([0-9]+)/?(&[\w-=]+)?$';

  final String title;

  const ShowAuthorPage(Key? key, this.title) : super(key: key);

  @override
  State<ShowAuthorPage> createState() => _ShowAuthorPageState();
}

class _ShowAuthorPageState extends State<ShowAuthorPage> {

  void _persist() {
    setState(() {
      print("update");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('???'),
            Text('test', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _persist,
        tooltip: 'Save',
        child: const Icon(Icons.add),
      ),
    );
  }
}



