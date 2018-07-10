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

  List<ParsingError> get errors => this._errors;
  F get form => this._form;

  bool hasErrors() => this._errors != null && this._errors.length > 0;

}

abstract class FormParser<F> {
  ParseResult<F> parse(Map rawForm);
}

class QuoteForm {
  String _text;

  QuoteForm(this._text);
}

class QuoteFormParser extends FormParser<QuoteForm> {
  ParseResult<QuoteForm> parse(Map rawForm) {
    Object textObj = rawForm["text"];
    if (textObj == null) {
      var errors = [new ParsingError("text", "Text cannot be empty")];
      return new ParseResult.failure(errors);
    }

    return null;
  }
}
