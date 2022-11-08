import 'package:shelf/shelf.dart';

import 'package:quotesbe/web/response.dart';
import 'package:quotesbe/storage/elasticsearch/exception.dart';


Response handleError(Exception ex) {
  if(ex is IndexingFailedException) {
    return responseInternalError();
  } else if(ex is DocUpdateFailedException) {
        return responseInternalError();
  } else if(ex is DocFindFailedException) {
    return responseNotFound();
  } 
  return responseInternalError();
}

