import 'package:quotesbe2/domain/common/model.dart';



class FindAuthorQuery {
  final String authorId;

  FindAuthorQuery(this.authorId);
}

class DeleteAuthorQuery {
  final String id;

  DeleteAuthorQuery(this.id);
}

class ListAuthorsQuery {
  late PageRequest pageRequest;

  ListAuthorsQuery(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsRequest [pageRequest: $pageRequest]";
}

class ListEventsByAuthorQuery {
  final String authorId;
  final PageRequest pageRequest;

  ListEventsByAuthorQuery(this.authorId, this.pageRequest);

  @override
  String toString() => "ListEventsByAuthorRequest [authorId: $authorId, pageRequest: $pageRequest]";
}
