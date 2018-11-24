import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';
import '../common/model.dart';

const insertBookStmt =
    "INSERT INTO Book (ID, TITLE, DESCRIPTION, AUTHOR_ID, CREATED_UTC) VALUES (@id, @title, @desc, @authorId, @created)";
const updateBookStmt =
    "UPDATE Book SET TITLE = @title, DESCRIPTION = @desc WHERE ID = @id";
const getBookStmt = "SELECT * FROM Book WHERE id = @id";
const deleteBookStmt = "DELETE FROM Book WHERE id = @id";
const listAuthorBooksStmt =
    "SELECT * FROM Book WHERE AUTHOR_ID = @authorId LIMIT @limit OFFSET @offset";
const authorBooksCountStmt =
    "SELECT count(*) FROM Book WHERE AUTHOR_ID = @authorId";

class BookRepository {
  PostgreSQLConnection _connection;

  BookRepository(this._connection);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) {
    return _connection
        .query(listAuthorBooksStmt, substitutionValues: {
          "limit": request.limit,
          "offset": request.offset,
          "authorId": authorId
        })
        .then((List<List<dynamic>> booksData) => booksData
            .map((List<dynamic> bookData) => Book.fromDB(bookData))
            .toList())
        .then((List<Book> books) =>
          _connection
              .query(authorBooksCountStmt,
                  substitutionValues: {"authorId": authorId})
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
        "desc": book.description
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return book;
      });

  Future<void> delete(String bookId) => _connection.execute(deleteBookStmt,
          substitutionValues: {"id": bookId}).then((count) {
        if (count == 0) throw FindFailedException();
      });
}
