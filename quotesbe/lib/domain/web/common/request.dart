import 'package:shelf/shelf.dart';

import 'package:quotesbe/domain/common/model.dart';


const defaultLimit = 2;
const defaultOffset = 0;

PageRequest extractPageRequest(Request request) {
  var params = request.url.queryParameters;

  var limitStr = params["limit"];
  var offsetStr = params["offset"];

  var limit = limitStr != null ? int.parse(limitStr) : defaultLimit;
  var offset = offsetStr != null ? int.parse(offsetStr) : defaultOffset;

  return PageRequest(limit, offset);
}

SearchQuery extractSearchQuery(Request request) {
  var params = request.url.queryParameters;
  var pageRequest = extractPageRequest(request);
  var phrase = params["searchPhrase"];
  return SearchQuery(phrase, pageRequest);
}
