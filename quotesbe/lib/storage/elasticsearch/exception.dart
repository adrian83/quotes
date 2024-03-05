import 'package:quotesbe/storage/elasticsearch/response.dart';

class IndexingFailedException<T> implements Exception {
  IndexResult result;
  T document;

  IndexingFailedException(this.document, this.result);

  @override
  String toString() =>
      "IndexingFailedException [document: $document, result: $result]";
}

class DocUpdateFailedException<T> implements Exception {
  UpdateResult result;
  T document;

  DocUpdateFailedException(this.document, this.result);

  @override
  String toString() =>
      "DocUpdateFailedException [document: $document, result: $result]";
}

class DocFindFailedException implements Exception {
  GetResult result;
  String id;

  DocFindFailedException(this.id, this.result);

  @override
  String toString() =>
      "DocFindFailedException [document id: $id, result: $result]";
}
