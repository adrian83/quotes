import '../common/exception.dart';
import '../common/form.dart';

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
  static final int minTitleLen = 1, maxTitleLen = 200;
  static final int minDescriptionLen = 1, maxDescriptionLen = 5000;

  bool _modificationDateRequired, _creationDateRequired;

  BookFormParser(this._modificationDateRequired, this._creationDateRequired);

  BookForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    String title = titleObj ?? titleObj.toString().trim();
    if (title == null || title.isEmpty) {
      errors.add(ParsingError("title", "Title cannot be empty"));
    } else if (title.length < minTitleLen || title.length > maxTitleLen) {
      errors.add(ParsingError("title",
          "Title length should be between $minTitleLen and $maxTitleLen"));
    }

    Object descriptionObj = rawForm["description"];
    String description = descriptionObj ?? descriptionObj.toString().trim();
    if (description == null || description.isEmpty) {
      errors.add(ParsingError("description", "Description cannot be empty"));
    } else if (title.length < minTitleLen || title.length > maxTitleLen) {
      errors.add(ParsingError("description",
          "Description length should be between $minDescriptionLen and $maxDescriptionLen"));
    }

    Object modificationDateObj = rawForm["modifiedUtc"];
    DateTime modifiedUtc =
        parseDate(modificationDateObj, _modificationDateRequired, errors);

    Object creationDateObj = rawForm["createdUtc"];
    DateTime createdUtc =
        parseDate(creationDateObj, _creationDateRequired, errors);

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return BookForm(titleObj.toString(), descriptionObj.toString(), modifiedUtc,
        createdUtc);
  }
}
