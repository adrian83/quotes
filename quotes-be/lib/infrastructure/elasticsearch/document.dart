import '../../common/json.dart';

abstract class Document implements Jsonable {
  String getId();
  //Map<dynamic, dynamic> toSave() => toJson();
  //Map<dynamic, dynamic> toUpdate() => toJson();
}

abstract class ESDocument extends Document implements Jsonable {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String eventId, operation;
  late DateTime modifiedUtc;

  ESDocument(this.eventId, this.operation) {
    modifiedUtc = DateTime.now().toUtc(); // modDateUtc == null ? DateTime.now().toUtc() : modDateUtc;
  }

  String getId() => eventId;

  Map toJson() => {"eventId": eventId, "operation": operation, "modifiedUtc": modifiedUtc.toIso8601String()};
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  Map<dynamic, dynamic> _doc;

  UpdateDoc(this._doc);

  Map toJson() => {"doc": _doc, "doc_as_upsert": _docAsUpsert, "detect_noop": _detectNoop};
}
