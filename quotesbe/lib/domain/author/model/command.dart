import 'package:uuid/uuid.dart';

import 'package:quotesbe/domain/author/model/entity.dart';

class NewAuthorCommand {
  final String name, description;

  NewAuthorCommand(this.name, this.description);

  Author toAuthor() => Author(
        const Uuid().v4(),
        name,
        description,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateAuthorCommand extends NewAuthorCommand {
  final String id;

  UpdateAuthorCommand(this.id, String name, String description)
      : super(name, description);

  @override
  Author toAuthor() =>
      Author(id, name, description, DateTime.now(), DateTime.now());
}
