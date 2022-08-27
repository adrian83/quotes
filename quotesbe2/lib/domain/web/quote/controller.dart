


import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

import 'package:quotesbe2/domain/author/service.dart';


class QuoteController {
    final Logger _logger = Logger('QuoteController');

  final AuthorService _authorService;

  QuoteController(this._authorService);


  Future<Response> find(Request request, String authorId, String bookId, String quoteId) async {

final String query = await request.readAsString();


    return Response.ok("authorId=$authorId, bookId=$bookId, quoteId=$quoteId");
  }


}