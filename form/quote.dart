import 'dart:convert';

import './common.dart';

class QuoteForm {
  String _text;

  QuoteForm(this._text);

  Map<String, Object> toJson() {
    var map = new Map<String, Object>();
    map["text"] = this._text;
    return map;
  }

  String toString() {
    return JSON.encode(this);
  }
}

class QuoteFormParser extends FormParser<QuoteForm> {
  ParseResult<QuoteForm> parse(Map rawForm) {
    Object textObj = rawForm["text"];
    if (textObj == null) {
      var errors = [new ParsingError("text", "Text cannot be empty")];
      return new ParseResult.failure(errors);
    }

    return new ParseResult.success(new QuoteForm(textObj.toString()));
  }
}
