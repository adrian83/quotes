import '../common/form.dart';
import '../common/exception.dart';

class QuoteForm {
  String _text;
  DateTime _modifiedUtc, _createdUtc;

  QuoteForm(this._text, this._modifiedUtc, this._createdUtc);

  String get text => _text;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  Map toJson() => {
        "text": _text,
        "modifiedUtc": _modifiedUtc.toIso8601String(),
        "createdUtc": _createdUtc.toIso8601String()
      };
}

class QuoteFormParser extends FormParser<QuoteForm> {
  static final int minTextLen = 1, maxTextLen = 5000;

  bool _modificationDateRequired, _creationDateRequired;

  QuoteFormParser(this._modificationDateRequired, this._creationDateRequired);

  QuoteForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object textObj = rawForm["text"];
    String text = textObj ?? textObj.toString().trim();
    if (text == null || text.isEmpty) {
      errors.add(ParsingError("text", "Text cannot be empty"));
    } else if (text.length < minTextLen || text.length > maxTextLen) {
      errors.add(ParsingError(
          "text", "Text length should be between $minTextLen and $maxTextLen"));
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

    return QuoteForm(textObj.toString(), modifiedUtc, createdUtc);
  }
}
