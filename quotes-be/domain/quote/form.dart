import '../common/form.dart';

class QuoteForm {
  String _text;

  QuoteForm(this._text);

  String get text => this._text;

  Map<String, Object> toJson() {
    var map = new Map<String, Object>();
    map["text"] = this.text;
    return map;
  }
}

class QuoteFormParser extends FormParser<QuoteForm> {
  ParseResult<QuoteForm> parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object textObj = rawForm["text"];
    if (textObj == null) {
        errors.add(new ParsingError("text", "Text cannot be empty"));
    }

    if(errors.length > 0){
        return new ParseResult.failure(errors);
    }
    var form = new QuoteForm(textObj.toString());
    return new ParseResult.success(form);
  }
}
