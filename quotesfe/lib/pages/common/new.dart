import 'package:flutter/material.dart';

import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/pages/common/page.dart';
import 'package:quotesfe/pages/widgets/common/entity_form.dart';

abstract class NewPage<T extends Entity, F extends EntityForm<T>>
    extends AbsPage {
  const NewPage(Key? key, String title) : super(key, title);

  @override
  State<NewPage<T, F>> createState() => _NewPageState<T, F>();

  F createEntityForm(BuildContext context, T? entity);

  Future<T> persist(T entity);

  String successMessage();

  Future<T?> init();

  bool hideFormOnSuccess() => false;
}

class _NewPageState<T extends Entity, F extends EntityForm<T>>
    extends PageState<NewPage<T, F>> {
  EntityForm<T>? _form;

  @override
  initState() {
    super.initState();

    widget.init().then((entity) {
      setState(() {
        _form = widget.createEntityForm(context, entity);
      });
    }).catchError((e) {
      showError(e);
    });
  }

  Function()? _persist(BuildContext context) => () {
        var entity = _form!.createEntity();
        widget.persist(entity).then((createdEntity) {
          showInfo(widget.successMessage());
        }).catchError((e) {
          showError(e);
        });
      };

  @override
  List<Widget> renderWidgets(BuildContext context) {
    if (isMessage() && widget.hideFormOnSuccess()) {
      return [];
    } else if (_form != null) {
      return [_form!.createForm(context, _persist(context))];
    }
    return [];
  }

  @override
  void dispose() {
    super.dispose();
    if (_form != null) {
      _form!.dispose();
    }
  }
}
