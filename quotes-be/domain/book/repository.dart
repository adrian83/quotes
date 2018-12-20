import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';
import '../common/model.dart';

const insertBookStmt =
    "INSERT INTO Book (ID, TITLE, DESCRIPTION, AUTHOR_ID, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @title, @desc, @authorId, @modified, @created)";
const updateBookStmt =
    "UPDATE Book SET TITLE = @title, DESCRIPTION = @desc, MODIFIED_UTC = @modified WHERE ID = @id";
const getBookStmt = "SELECT * FROM Book WHERE id = @id";
const deleteBookStmt = "DELETE FROM Book WHERE id = @id";
const deleteAuthorsBooks = "DELETE FROM Book WHERE AUTHOR_ID = @authorId";
const listAuthorBooksStmt =
    "SELECT * FROM Book WHERE AUTHOR_ID = @authorId LIMIT @limit OFFSET @offset";
const authorBooksCountStmt =
    "SELECT count(*) FROM Book WHERE AUTHOR_ID = @authorId";

class BookRepository {
  PostgreSQLConnection _connection;

  BookRepository(this._connection);

  Future<Page<Book>> findAuthorBooks(String authorId, PageRequest request) {
    return _connection
        .query(listAuthorBooksStmt, substitutionValues: {
          "limit": request.limit,
          "offset": request.offset,
          "authorId": authorId
        })
        .then((List<List<dynamic>> booksData) => booksData
            .map((List<dynamic> bookData) => Book.fromDB(bookData))
            .toList())
        .then((List<Book> books) => _connection
            .query(authorBooksCountStmt,
                substitutionValues: {"authorId": authorId})
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, books)));
  }

  Future<Page<Book>> findBooks(String searchPhrase, PageRequest request) {

    var phrase = searchPhrase ?? "";
    print(phrase);

    Map<String, Object> params = {
      "limit": request.limit,
      "offset": request.offset,
      "phrase": phrase
    };

    // TODO fix - use prepared statement.
    var stmt =
        "SELECT * FROM Book WHERE TITLE ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%' LIMIT @limit OFFSET @offset";
    var countStmt = "SELECT count(*) FROM Book WHERE TITLE ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%'";

    print(stmt);
    return _connection
        .query(stmt, substitutionValues: params)
        .then((List<List<dynamic>> booksData) => booksData
            .map((List<dynamic> bookData) => Book.fromDB(bookData))
            .toList())
        .then((List<Book> books) => _connection
            .query(countStmt)
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, books)));
  }

  Future<void> save(Book book) =>
      _connection.execute(insertBookStmt, substitutionValues: {
        "id": book.id,
        "title": book.title,
        "desc": book.description,
        "authorId": book.authorId,
        "modified": book.modifiedUtc,
        "created": book.createdUtc
      });

  Future<Book> find(String bookId) {
    return _connection.query(getBookStmt,
        substitutionValues: {"id": bookId}).then((List<List<dynamic>> l) {
      if (l.length == 0) throw FindFailedException();
      var bookData = l[0];

      for (int i = 0; i < bookData.length; i++) {
        print("$i  ${bookData[i]} ${bookData[i].runtimeType}\n");
      }

      print(bookData);
      return Book.fromDB(bookData);
    });
  }

  Future<Book> update(Book book) =>
      _connection.execute(updateBookStmt, substitutionValues: {
        "id": book.id,
        "title": book.title,
        "desc": book.description,
        "modified": book.modifiedUtc
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return book;
      });

  Future<void> delete(String bookId) => _connection.execute(deleteBookStmt,
          substitutionValues: {"id": bookId}).then((count) {
        if (count == 0) throw FindFailedException();
      });

  Future<void> deleteByAuthor(String authorId) => _connection.execute(deleteAuthorsBooks, substitutionValues: {
        "authorId": authorId
      });
}
