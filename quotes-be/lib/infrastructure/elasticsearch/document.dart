import '../../common/json.dart';

abstract class Document implements Jsonable {
  String getId();
}

abstract class ESDocument extends Document implements Jsonable {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String eventId, operation;
  late DateTime modifiedUtc;

  ESDocument(this.eventId, this.operation) {
    //, [DateTime modDateUtc]) {
    modifiedUtc = DateTime.now().toUtc(); // modDateUtc == null ? DateTime.now().toUtc() : modDateUtc;
  }

  String getId() => eventId;

  Map toJson() => {"eventId": eventId, "operation": operation, "modifiedUtc": modifiedUtc.toIso8601String()};
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  Document _doc;

  UpdateDoc(this._doc);

  Map toJson() => {"doc": _doc.toJson(), "doc_as_upsert": _docAsUpsert, "detect_noop": _detectNoop};
}
