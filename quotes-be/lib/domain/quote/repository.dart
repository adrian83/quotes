import 'dart:async';

import 'package:postgres/postgres.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const insertQuoteStmt =
    "INSERT INTO Quote (ID, TEXT, AUTHOR_ID, BOOK_ID, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @text, @authorId, @bookId, @modified, @created)";

const updateQuoteStmt = "UPDATE Quote SET TEXT = @text, MODIFIED_UTC = @modified WHERE ID = @id";

const getQuoteStmt = "SELECT * FROM Quote WHERE id = @id";

const deleteQuoteStmt = "DELETE FROM Quote WHERE id = @id";

const listBookQuotesStmt = "SELECT * FROM Quote WHERE BOOK_ID = @bookId ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

const bookQuotesCountStmt = "SELECT count(*) FROM Quote WHERE BOOK_ID = @bookId";

const deleteAuthorQuotesStmt = "DELETE FROM Quote WHERE AUTHOR_ID = @authorId";

const deleteBookQuotesStmt = "DELETE FROM Quote WHERE BOOK_ID = @bookId";

// TODO fix - use prepared statement.
var findQuotesStmt = (String phrase) => "SELECT * FROM Quote WHERE TEXT ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

var findQuotesCountStmt = (String phrase) => "SELECT count(*) FROM Quote WHERE TEXT ILIKE '%$phrase%'";

RowDecoder<Quote> quoteRowDecoder = (List<dynamic> row) => Quote.fromDB(row);

class QuoteRepository extends Repository<Quote> {
  QuoteRepository(PostgreSQLConnection connection) : super(connection, quoteRowDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) {
    var limit = request.pageRequest.limit;
    var offset = request.pageRequest.offset;
      
      return listAll(listBookQuotesStmt, {"limit": limit, "offset": offset, "bookId": request.bookId}).then((List<Quote> quotes) =>
          count(bookQuotesCountStmt, {"bookId": request.bookId}).then((total) => PageInfo(limit, offset, total)).then((info) => Page(info, quotes)));
  }

  Future<Page<Quote>> findQuotes(SearchQuoteRequest request) {
    var phrase = request.searchPhrase ?? "";
    var limit = request.pageRequest.limit;
    var offset = request.pageRequest.offset;

    Map<String, Object> params = {"limit": limit, "offset": offset};

    return listAll(findQuotesStmt(phrase), params).then((List<Quote> quotes) =>
        count(findQuotesCountStmt(phrase), {}).then((total) => PageInfo(limit, offset, total)).then((info) => Page(info, quotes)));
  }

  Future<Quote> save(Quote quote) => saveByStatement(insertQuoteStmt, {
        "id": quote.id,
        "text": quote.text,
        "authorId": quote.authorId,
        "bookId": quote.bookId,
        "modified": quote.modifiedUtc,
        "created": quote.createdUtc
      }).then((_) => quote);

  Future<Quote> find(String quoteId) => findOneByStatement(getQuoteStmt, {"id": quoteId});

  Future<Quote> update(Quote quote) =>
      updateAtLeastOne(updateQuoteStmt, {"id": quote.id, "text": quote.text, "modified": quote.modifiedUtc}).then(((_) => quote));

  Future<void> delete(String quoteId) => deleteAtLeastOne(deleteQuoteStmt, {"id": quoteId});

  Future<void> deleteByAuthor(String authorId) => deleteAll(deleteAuthorQuotesStmt, {"authorId": authorId});

  Future<void> deleteByBook(String bookId) => deleteAll(deleteBookQuotesStmt, {"bookId": bookId});
}
