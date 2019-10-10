import 'dart:async';

import 'package:postgres/postgres.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const insertBookStmt =
    "INSERT INTO Book (ID, TITLE, DESCRIPTION, AUTHOR_ID, " + "MODIFIED_UTC, CREATED_UTC) VALUES (@id, @title, @desc, @authorId, " + "@modified, @created)";

const updateBookStmt = "UPDATE Book SET TITLE = @title, DESCRIPTION = @desc, " + "MODIFIED_UTC = @modified WHERE ID = @id";

const getBookStmt = "SELECT * FROM Book WHERE id = @id";

const deleteBookStmt = "DELETE FROM Book WHERE id = @id";

const deleteAuthorBooks = "DELETE FROM Book WHERE AUTHOR_ID = @authorId";

const listAuthorBooksStmt = "SELECT * FROM Book WHERE AUTHOR_ID = @authorId " + "ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

const authorBooksCountStmt = "SELECT count(*) FROM Book WHERE AUTHOR_ID = @authorId";

// TODO fix - use prepared statement.
var findBooksStmt = (String phrase) =>
    "SELECT * FROM Book WHERE TITLE ILIKE '%$phrase%' OR DESCRIPTION " + "ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

var findBooksCountStmt = (String phrase) => "SELECT count(*) FROM Book WHERE TITLE ILIKE '%$phrase%' OR DESCRIPTION " + "ILIKE '%$phrase%'";

RowDecoder<Book> bookRowDecoder = (List<dynamic> row) => Book.fromDB(row);

class BookRepository extends Repository<Book> {
  BookRepository(PostgreSQLConnection connection) : super(connection, bookRowDecoder);

  Future<Page<Book>> findAuthorBooks(String authorId, PageRequest request) =>
      listAll(listAuthorBooksStmt, {"limit": request.limit, "offset": request.offset, "authorId": authorId}).then((List<Book> books) =>
          count(authorBooksCountStmt, {"authorId": authorId})
              .then((total) => PageInfo(request.limit, request.offset, total))
              .then((info) => Page(info, books)));

  Future<Page<Book>> findBooks(String searchPhrase, PageRequest request) {
    Map<String, Object> params = {"limit": request.limit, "offset": request.offset, "phrase": searchPhrase ?? ""};

    return listAll(findBooksStmt(params["phrase"]), params).then((List<Book> books) =>
        count(findBooksCountStmt(params["phrase"]), {}).then((total) => PageInfo(request.limit, request.offset, total)).then((info) => Page(info, books)));
  }

  Future<void> save(Book book) => saveByStatement(insertBookStmt,
      {"id": book.id, "title": book.title, "desc": book.description, "authorId": book.authorId, "modified": book.modifiedUtc, "created": book.createdUtc});

  Future<Book> find(String bookId) => findOneByStatement(getBookStmt, {"id": bookId});

  Future<Book> update(Book book) =>
      updateAtLeastOne(updateBookStmt, {"id": book.id, "title": book.title, "desc": book.description, "modified": book.modifiedUtc}).then((_) => book);

  Future<void> delete(String bookId) => deleteAtLeastOne(deleteBookStmt, {"id": bookId});

  Future<void> deleteByAuthor(String authorId) => deleteAll(deleteAuthorBooks, {"authorId": authorId});
}
