import '../common/form.dart';
import '../common/exception.dart';

class BookForm {
  String _title, _description;
  DateTime _modifiedUtc, _createdUtc;

  BookForm(this._title, this._description, this._modifiedUtc, this._createdUtc);

  String get title => _title;
  String get description => _description;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  Map<String, Object> toJson() => {
        "title": _title,
        "description": _description,
        "modifiedUtc": _modifiedUtc.toIso8601String(),
        "createdUtc": _createdUtc.toIso8601String()
      };
}

class BookFormParser extends FormParser<BookForm> {
  bool _modificationDateRequired, _creationDateRequired;

  BookFormParser(this._modificationDateRequired, this._creationDateRequired);

  BookForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    if (titleObj == null || titleObj.toString().trim().isEmpty) {
      errors.add(ParsingError("title", "Title cannot be empty"));
    }

    Object descriptionObj = rawForm["description"];
    if (descriptionObj == null || descriptionObj.toString().trim().isEmpty) {
      errors.add(ParsingError("title", "Description cannot be empty"));
    }

    Object modificationDateObj = rawForm["modifiedUtc"];
    print("MODIFICATION DATE $modificationDateObj");
    DateTime modifiedUtc =
        parseDate(modificationDateObj, _modificationDateRequired, errors);

    Object creationDateObj = rawForm["createdUtc"];
    print("CREATION DATE $creationDateObj");
    DateTime createdUtc =
        parseDate(creationDateObj, _creationDateRequired, errors);

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return BookForm(titleObj.toString(), descriptionObj.toString(), modifiedUtc,
        createdUtc);
  }
}
