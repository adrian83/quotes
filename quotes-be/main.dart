import 'dart:async';
import 'dart:io';

import './handler/common.dart';
import './handler/not_found.dart';
import './handler/options.dart';
import './handler/quote/list_quotes.dart';
import './handler/quote/add_quote.dart';
import './handler/quote/update_quote.dart';
import './handler/quote/delete_quote.dart';
import './handler/quote/get_quote.dart';

import './handler/author/list_authors.dart';
import './handler/author/add_author.dart';
import './handler/author/update_author.dart';
import './handler/author/get_author.dart';
import './handler/author/delete_author.dart';

import './handler/book/list_books.dart';
import './handler/book/add_book.dart';
import './handler/book/delete_book.dart';
import './handler/book/get_book.dart';
import './handler/book/update_book.dart';

import './domain/author/model.dart';
import './domain/author/service.dart';
import './domain/author/repository.dart';

import './domain/quote/model.dart';
import './domain/quote/service.dart';
import './domain/quote/repository.dart';

import './domain/book/model.dart';
import './domain/book/service.dart';
import './domain/book/repository.dart';

import 'store/elasticsearch_store.dart';

import 'config/config.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  String configLocation = args[0];
  Config config = await readConfig(configLocation);

  HttpClient client = new HttpClient();

  var esConfig = config.elasticsearch;

  var authorEsStore = new ESStore<Author>(
      client, esConfig.host, esConfig.port, esConfig.authorsIndex);

  var bookEsStore = new ESStore<Book>(
      client, esConfig.host, esConfig.port, esConfig.booksIndex);

      var quoteEsStore = new ESStore<Quote>(
          client, esConfig.host, esConfig.port, esConfig.quotesIndex);

  var quoteRepository = new QuotesRepository(quoteEsStore);
  var quotesService = new QuotesService(quoteRepository);

  var authorRepository = new AuthorRepository(authorEsStore);
  var authorService = new AuthorService(authorRepository);

  var bookRepository = new BookRepository(bookEsStore);
  var bookService = new BookService(bookRepository);

  var notFoundHandler = new NotFoundHandler();
  var optionsHandler = new OptionsHandler();

  var addAuthorHandler = new AddAuthorHandler(authorService);
  var listAuthorsHandler = new ListAuthorsHandler(authorService);
  var getAuthorHandler = new GetAuthorHandler(authorService);
  var updateAuthorHandler = new UpdateAuthorHandler(authorService);
  var deleteAuthorHandler = new DeleteAuthorHandler(authorService);

  var addBookHandler = new AddBookHandler(bookService);
  var listBooksHandler = new ListBooksHandler(bookService);
  var getBookHandler = new GetBookHandler(bookService);
  var updateBookHandler = new UpdateBookHandler(bookService);
  var deleteBookHandler = new DeleteBookHandler(bookService);

  var addQuoteHandler = new AddQuoteHandler(quotesService);
  var listQuotesHandler = new ListQuotesHandler(quotesService);
  var getQuoteHandler = new GetQuoteHandler(quotesService);
  var updateQuoteHandler = new UpdateQuoteHandler(quotesService);
  var deleteQuoteHandler = new DeleteQuoteHandler(quotesService);

  var handlers = [
    addAuthorHandler,
    getAuthorHandler,
    updateAuthorHandler,
    deleteAuthorHandler,
    listAuthorsHandler,
    addBookHandler,
    getBookHandler,
    updateBookHandler,
    deleteBookHandler,
    listBooksHandler,
    addQuoteHandler,
    getQuoteHandler,
    updateQuoteHandler,
    deleteQuoteHandler,
    listQuotesHandler
  ];

  Author a1 = await authorRepository.save(new Author(null, "Adam Mickiewicz"));
  Author a2 = await authorRepository.save(new Author(null, "Henryk Sienkiewicz"));
  Author a3 = await authorRepository.save(new Author(null, "Shakespear"));


   Book b1 = await bookRepository.save(new Book(null, "Dziady", a1.id));
   await bookRepository.save(new Book(null, "Pan Tadeusz", a1.id));
   await bookRepository.save(new Book(null, "Switez", a1.id));

   await bookRepository.save(new Book(null, "Balladyna", a2.id));
   await bookRepository.save(new Book(null, "Beniowski", a2.id));
   await bookRepository.save(new Book(null, "Kordian", a2.id));

   await bookRepository.save(new Book(null, "Hamlet", a3.id));
   await bookRepository.save(new Book(null, "Makbet", a3.id));
   await bookRepository.save(new Book(null, "Burza", a3.id));

  await quoteRepository.save(
      new Quote(null, "Ciemno wszedzie, glucho wszedzie... 1", a1.id, b1.id));
  await quoteRepository.save(
      new Quote(null, "Ciemno wszedzie, glucho wszedzie... 2", a1.id, b1.id));
  await quoteRepository.save(
      new Quote(null, "Ciemno wszedzie, glucho wszedzie... 3", a1.id, b1.id));

  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5050);

  await for (HttpRequest request in server) {
    var found = false;

    for (Handler handler in handlers) {
      if (handler.canHandle(request.uri.path, request.method)) {
        handler.handle(request);
        found = true;
        break;
      }
    }

    if (request.method == "OPTIONS") {
      optionsHandler.handle(request);
      continue;
    }

    if (!found) {
      notFoundHandler.handle(request);
    }
  }
}
