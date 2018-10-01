import 'dart:async';

import 'model.dart';
import 'repository.dart';
import '../common/model.dart';

class AuthorService {
  AuthorRepository _authorRepository;

  AuthorService(this._authorRepository);

  Future<Page<Author>> findAuthors(PageRequest request) => _authorRepository.list(request);
  Future<Author> save(Author author) => _authorRepository.save(author);
  Future<Author> update(Author author) => _authorRepository.update(author);
  Future<Author> find(String authorId) => _authorRepository.find(authorId);
  Future<void> delete(String authorId) => _authorRepository.delete(authorId);

}
