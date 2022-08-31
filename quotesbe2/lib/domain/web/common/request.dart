



import 'package:quotesbe2/domain/common/model.dart';
import 'package:shelf/shelf.dart';


const defaultLimit = 2;
const defaultOffset = 0;

SearchQuery extractSearchQuery(Request request) {
      var params = request.url.queryParameters;

    var limitStr = params["limit"];
    var offsetStr = params["offset"]; 

    var phrase = params["searchPhrase"];
    var limit = limitStr != null ? int.parse(limitStr) : defaultLimit;
    var offset = offsetStr != null ? int.parse(offsetStr) : defaultOffset;

    return SearchQuery(phrase, offset, limit);
}