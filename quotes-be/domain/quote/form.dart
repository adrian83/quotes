import '../common/form.dart';
import '../common/exception.dart';

class QuoteForm {
  String _text;

  QuoteForm(this._text);

  String get text => this._text;

  Map toJson() => {"text": _text};
}

class QuoteFormParser extends FormParser<QuoteForm> {
  QuoteForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object textObj = rawForm["text"];
    if (textObj == null) {
      errors.add(ParsingError("text", "Text cannot be empty"));
    }

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return QuoteForm(textObj.toString());
  }
}
