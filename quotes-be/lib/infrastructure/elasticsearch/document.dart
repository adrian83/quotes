import '../../common/json.dart';

abstract class ESDocument implements Jsonable {
  static final String created = "created",
      modified = "modified",
      deleted = "deleted";

  String _eventId, _operation;
  DateTime _modifiedUtc;

  ESDocument(this._eventId, this._operation, [DateTime modifiedUtc]) {
    _modifiedUtc = modifiedUtc == null ? DateTime.now().toUtc() : modifiedUtc;
  }

  String get eventId => _eventId;

  Map toJson() => {
        "eventId": _eventId,
        "operation": _operation,
        "modifiedUtc": _modifiedUtc.toIso8601String()
      };
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  ESDocument _doc;

  UpdateDoc(this._doc);

  Map toJson() => {
        "doc": _doc.toJson(),
        "doc_as_upsert": _docAsUpsert,
        "detect_noop": _detectNoop
      };
}
