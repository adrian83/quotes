import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';
import 'repository.dart';
import 'event_repository.dart';

import '../common/model.dart';

class BookService {
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;

  BookService(this._bookRepository, this._bookEventRepository);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) =>
      _bookRepository.findBooks(authorId, request);

  Future<Book> save(Book book){
    book.id = Uuid().v4();
return _bookRepository.save(book).then((_) => _bookEventRepository.save(book));
// _bookRepository.save(book);
  } 

  Future<Book> update(Book book) => _bookRepository.update(book);
  Future<Book> find(String bookId) => _bookRepository.find(bookId);
  Future<void> delete(String bookId) => _bookRepository.delete(bookId);
}
