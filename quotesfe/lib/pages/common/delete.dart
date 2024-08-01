import 'package:flutter/material.dart';

import 'package:quotesfe/pages/common/page.dart';

abstract class DeletePage extends AbsPage {
  const DeletePage(super.key, super.title);

  @override
  State<DeletePage> createState() => _DeletePageState();

  String question();

  String successMessage();

  Future<void> deleteEntity();
}

class _DeletePageState extends PageState<DeletePage> {
  void _delete() {
    widget.deleteEntity().then((_) {
      showInfo(widget.successMessage());
    }).catchError((e) {
      showError(e);
    });
  }

  @override
  List<Widget> renderWidgets(BuildContext context) {
    if (!isMessage()) {
      return [
        const SizedBox(height: 20),
        Text(widget.question()),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _delete,
          child: const Text('Delete'),
        )
      ];
    }

    return [];
  }
}
