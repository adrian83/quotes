import 'model.dart';
import 'repository.dart';
import '../common/model.dart';

class AuthorService {
  AuthorRepository _authorRepository;

  AuthorService(this._authorRepository);

  Page<Author> findAuthors() => _authorRepository.list();
  Author save(Author author) => _authorRepository.save(author);
  Author update(Author author) => _authorRepository.update(author);
  Author find(String authorId) => _authorRepository.find(authorId);

  void delete(String authorId) {
    _authorRepository.delete(authorId);
  }

}
