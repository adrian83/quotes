import 'package:quotes_common/domain/author.dart';

class NewAuthorCommand {
  final String name, description;

  NewAuthorCommand(this.name, this.description);

  Author toAuthor() => Author.create(name, description);
}

class UpdateAuthorCommand extends NewAuthorCommand {
  final String id;

  UpdateAuthorCommand(this.id, String name, String description) : super(name, description);

  @override
  Author toAuthor() => Author(id, name, description, DateTime.now(), DateTime.now());
}
