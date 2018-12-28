import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';
import '../common/model.dart';

const insertQuoteStmt =
    "INSERT INTO Quote (ID, TEXT, AUTHOR_ID, BOOK_ID, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @text, @authorId, @bookId, @modified, @created)";
const updateQuoteStmt = "UPDATE Quote SET TEXT = @text, MODIFIED_UTC = @modified WHERE ID = @id";
const getQuoteStmt = "SELECT * FROM Quote WHERE id = @id";
const deleteQuoteStmt = "DELETE FROM Quote WHERE id = @id";
const listBookQuotesStmt =
    "SELECT * FROM Quote WHERE BOOK_ID = @bookId ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";
const bookQuotesCountStmt =
    "SELECT count(*) FROM Quote WHERE BOOK_ID = @bookId";
const deleteAuthorQuotesStmt = "DELETE FROM Quote WHERE AUTHOR_ID = @authorId";
const deleteBookQuotesStmt = "DELETE FROM Quote WHERE BOOK_ID = @bookId";

class QuoteRepository {
  PostgreSQLConnection _connection;

  QuoteRepository(this._connection);

  Future<Page<Quote>> findBookQuotes(String bookId, PageRequest request) {
    return _connection
        .query(listBookQuotesStmt, substitutionValues: {
          "limit": request.limit,
          "offset": request.offset,
          "bookId": bookId
        })
        .then((List<List<dynamic>> quotesData) => quotesData
            .map((List<dynamic> quoteData) => Quote.fromDB(quoteData))
            .toList())
        .then((List<Quote> quotes) => _connection
            .query(bookQuotesCountStmt, substitutionValues: {"bookId": bookId})
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, quotes)));
  }

Future<Page<Quote>>findQuotes(String searchPhrase, PageRequest request) {

    var phrase = searchPhrase ?? "";
    print(phrase);

    Map<String, Object> params = {
      "limit": request.limit,
      "offset": request.offset,
      "phrase": phrase
    };

    // TODO fix - use prepared statement.
    var stmt = "SELECT * FROM Quote WHERE TEXT ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";
    var countStmt = "SELECT count(*) FROM Quote WHERE TEXT ILIKE '%$phrase%'";

    return _connection
        .query(stmt, substitutionValues: params)
        .then((List<List<dynamic>> quotesData) => quotesData
            .map((List<dynamic> quoteData) => Quote.fromDB(quoteData))
            .toList())
        .then((List<Quote> quotes) => _connection
            .query(countStmt)
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, quotes)));

}

  Future<Quote> save(Quote quote) =>
      _connection.execute(insertQuoteStmt, substitutionValues: {
        "id": quote.id,
        "text": quote.text,
        "authorId": quote.authorId,
        "bookId": quote.bookId,
        "modified": quote.modifiedUtc,
        "created": quote.createdUtc
      }).then((_) => quote);

  Future<Quote> find(String quoteId) {
    return _connection.query(getQuoteStmt,
        substitutionValues: {"id": quoteId}).then((List<List<dynamic>> l) {
      if (l.length == 0) throw FindFailedException();
      var quoteData = l[0];

      for (int i = 0; i < quoteData.length; i++) {
        print("$i  ${quoteData[i]} ${quoteData[i].runtimeType}\n");
      }

      print(quoteData);
      return Quote.fromDB(quoteData);
    });
  }

  Future<Quote> update(Quote quote) =>
      _connection.execute(updateQuoteStmt, substitutionValues: {
        "id": quote.id,
        "text": quote.text,
        "modified": quote.modifiedUtc
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return quote;
      });

  Future<void> delete(String quoteId) => _connection.execute(deleteQuoteStmt,
          substitutionValues: {"id": quoteId}).then((count) {
        if (count == 0) throw FindFailedException();
      });

  Future<void> deleteByAuthor(String authorId) =>
      _connection.execute(deleteAuthorQuotesStmt,
          substitutionValues: {"authorId": authorId});

  Future<void> deleteByBook(String bookId) =>_connection
      .execute(deleteBookQuotesStmt, substitutionValues: {"bookId": bookId});

}
