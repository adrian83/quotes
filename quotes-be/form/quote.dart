import './common.dart';

class QuoteForm {
  String _text, _language;

  QuoteForm(this._text, this._language);

  String get txt => this._text;
  String get language => this._language;

  Map<String, Object> toJson() {
    var map = new Map<String, Object>();
    map["text"] = this._text;
    map["language"] = language;
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

    Object langObj = rawForm["language"];
    if (langObj == null) {
        errors.add(new ParsingError("language", "Language cannot be empty"));
    }

    if(errors.length > 0){
        return new ParseResult.failure(errors);
    }
    return new ParseResult.success(new QuoteForm(textObj.toString(), langObj.toString()));
  }
}
