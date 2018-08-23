import 'model.dart';
import 'repository.dart';

class AuthorService {
  AuthorRepository _authorRepository;

  AuthorService(this._authorRepository);

  List<Author> findAuthors() => _authorRepository.list();
  Author save(Author author) => _authorRepository.save(author);
  Author update(Author author) => _authorRepository.update(author);
  Author find(String authorId) => _authorRepository.find(authorId);

  void delete(String authorId) {
    _authorRepository.delete(authorId);
  }

}
