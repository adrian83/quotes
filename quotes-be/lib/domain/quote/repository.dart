import 'dart:async';

import 'package:postgres/postgres.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const insertQuoteStmt = "INSERT INTO Quote (ID, TEXT, AUTHOR_ID, BOOK_ID, " +
    "MODIFIED_UTC, CREATED_UTC) VALUES (@id, @text, @authorId, @bookId, " +
    "@modified, @created)";

const updateQuoteStmt = "UPDATE Quote SET TEXT = @text, " + "MODIFIED_UTC = @modified WHERE ID = @id";

const getQuoteStmt = "SELECT * FROM Quote WHERE id = @id";

const deleteQuoteStmt = "DELETE FROM Quote WHERE id = @id";

const listBookQuotesStmt =
    "SELECT * FROM Quote WHERE BOOK_ID = @bookId " + "ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

const bookQuotesCountStmt = "SELECT count(*) FROM Quote WHERE BOOK_ID = @bookId";

const deleteAuthorQuotesStmt = "DELETE FROM Quote WHERE AUTHOR_ID = @authorId";

const deleteBookQuotesStmt = "DELETE FROM Quote WHERE BOOK_ID = @bookId";

// TODO fix - use prepared statement.
var findQuotesStmt = (String phrase) =>
    "SELECT * FROM Quote WHERE TEXT " + "ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

var findQuotesCountStmt = (String phrase) => "SELECT count(*) FROM Quote WHERE TEXT ILIKE '%$phrase%'";

RowDecoder<Quote> quoteRowDecoder = (List<dynamic> row) => Quote.fromDB(row);

class QuoteRepository extends Repository<Quote> {
  QuoteRepository(PostgreSQLConnection connection) : super(connection, quoteRowDecoder);

  Future<Page<Quote>> findBookQuotes(String bookId, PageRequest request) =>
      listAll(listBookQuotesStmt, {"limit": request.limit, "offset": request.offset, "bookId": bookId}).then(
          (List<Quote> quotes) => count(bookQuotesCountStmt, {"bookId": bookId})
              .then((total) => PageInfo(request.limit, request.offset, total))
              .then((info) => Page(info, quotes)));

  Future<Page<Quote>> findQuotes(String searchPhrase, PageRequest request) {
    Map<String, Object> params = {"limit": request.limit, "offset": request.offset, "phrase": searchPhrase ?? ""};

    return listAll(findQuotesStmt(params["phrase"]), params).then((List<Quote> quotes) =>
        count(findQuotesCountStmt(params["phrase"]), {})
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, quotes)));
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
      updateAtLeastOne(updateQuoteStmt, {"id": quote.id, "text": quote.text, "modified": quote.modifiedUtc});

  Future<void> delete(String quoteId) => deleteAtLeastOne(deleteQuoteStmt, {"id": quoteId});

  Future<void> deleteByAuthor(String authorId) => deleteAll(deleteAuthorQuotesStmt, {"authorId": authorId});

  Future<void> deleteByBook(String bookId) => deleteAll(deleteBookQuotesStmt, {"bookId": bookId});
}
