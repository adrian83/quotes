import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';
import '../common/model.dart';

const insertQuoteStmt =
    "INSERT INTO Quote (ID, TEXT, AUTHOR_ID, BOOK_ID, CREATED_UTC) VALUES (@id, @text, @authorId, @bookId, @created)";
const updateQuoteStmt = "UPDATE Quote SET TEXT = @text WHERE ID = @id";
const getQuoteStmt = "SELECT * FROM Quote WHERE id = @id";
const deleteQuoteStmt = "DELETE FROM Quote WHERE id = @id";
const listBookQuotesStmt =
    "SELECT * FROM Quote WHERE BOOK_ID = @bookId LIMIT @limit OFFSET @offset";
const bookQuotesCountStmt =
    "SELECT count(*) FROM Quote WHERE BOOK_ID = @bookId";

class QuoteRepository {
  PostgreSQLConnection _connection;

  QuoteRepository(this._connection);

  Future<Page<Quote>> findQuotes(String bookId, PageRequest request) {
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

  Future<Quote> save(Quote quote) =>
      _connection.execute(insertQuoteStmt, substitutionValues: {
        "id": quote.id,
        "text": quote.text,
        "authorId": quote.authorId,
        "bookId": quote.bookId,
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
        "text": quote.text
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return quote;
      });

  Future<void> delete(String quoteId) => _connection.execute(deleteQuoteStmt,
          substitutionValues: {"id": quoteId}).then((count) {
        if (count == 0) throw FindFailedException();
      });
}
