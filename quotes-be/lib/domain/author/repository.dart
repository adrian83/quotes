import 'dart:async';

import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const modifiedParam = "modified";
const createdParam = "created";
const descParam = "desc";
const nameParam = "name";
const idParam = "id";
const limitParam = "limit";
const offsetParam = "offset";
const phraseParam = "phrase";

const insertAuthorStmt =
    "INSERT INTO Author (ID, NAME, DESCRIPTION, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @name, @desc, @modified, @created)";

const updateAuthorStmt = "UPDATE Author SET NAME = @name, DESCRIPTION = @desc, MODIFIED_UTC = @modified WHERE ID = @id";

const getAuthorStmt = "SELECT * FROM Author WHERE id = @id";

const deleteAuthorStmt = "DELETE FROM Author WHERE id = @id";

// TODO fix - use prepared statement.
var findAuthorsStmt = (String phrase) =>
    "SELECT * FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

var findAuthorsCountStmt =
    (String phrase) => "SELECT count(*) FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%'";


RowDecoder<Author> authorRowDecoder = (List<dynamic> row) => Author.fromDB(row);

class AuthorRepository extends Repository<Author> {
  AuthorRepository(PostgreSQLConnection connection) : super(connection, authorRowDecoder);

  Future<void> save(Author author) => saveByStatement(insertAuthorStmt, insertParams(author));

  Future<Author> find(String authorId) => findOneByStatement(getAuthorStmt, idParameter(authorId));

  Future<Author> update(Author author) => updateAtLeastOne(updateAuthorStmt, updateParams(author)).then((_) => author);

  Future<void> delete(String authorId) => deleteAtLeastOne(deleteAuthorStmt, idParameter(authorId));

  Future<Page<Author>> findAuthors(String searchPhrase, PageRequest request) =>
      Future.value(findByPhraseParams(searchPhrase, request))
          .then((params) => listAll(findAuthorsStmt(orEmpty(searchPhrase)), params))
          .then((List<Author> authors) => count(findAuthorsCountStmt(orEmpty(searchPhrase)), {})
              .then((total) => PageInfo(request.limit, request.offset, total))
              .then((info) => Page(info, authors)));

  String orEmpty(String text) => text ?? "";

  Map<String, Object> findByPhraseParams(String phrase, PageRequest request) =>
      {limitParam: request.limit, offsetParam: request.offset, phraseParam: orEmpty(phrase)};

  Map<String, Object> idParameter(String authorId) => {idParam: authorId};

  Map<String, Object> updateParams(Author author) =>
      {nameParam: author.name, modifiedParam: author.modifiedUtc, descParam: author.description};

  Map<String, Object> insertParams(Author author) => {
        idParam: author.id,
        nameParam: author.name,
        descParam: author.description,
        modifiedParam: author.modifiedUtc,
        createdParam: author.createdUtc
      };
}
