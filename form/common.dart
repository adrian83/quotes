class ParsingError {
  String _field, _message;

  ParsingError(this._field, this._message);

  String get field => this._field;
  String get message => this._message;
}

class ParseResult<F> {
  F _form;
  List<ParsingError> _errors;

  ParseResult.failure(this._errors);
}

abstract class FormParser<F> {
  ParsingResult<F> parse(Map rawForm);
}

class QuoteForm {
  String _text;

  QuoteForm(this._text);
}

class QuoteFormParser extends FormParser<QuoteForm> {
  ParsingResult<QuoteForm> parse(Map rawForm) {
    Object textObj = rawForm["text"];
    if (textObj == null) {
      var errors = [new ParsingError("text", "Text cannot be empty")];
      return new ParseResult.failure(errors);
    }

    return null;
  }
}
