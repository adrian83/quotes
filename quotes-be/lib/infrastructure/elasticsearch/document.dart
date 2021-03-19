import '../../common/json.dart';

abstract class Document implements Jsonable {
  String getId();
  Map<dynamic, dynamic> toSave() => toJson();
  Map<dynamic, dynamic> toUpdate() => toJson();
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  Map<dynamic, dynamic> _doc;

  UpdateDoc(this._doc);

  Map toJson() => {"doc": _doc, "doc_as_upsert": _docAsUpsert, "detect_noop": _detectNoop};
}
