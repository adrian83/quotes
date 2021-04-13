import '../handler/author/author.dart';
import '../handler/book/book.dart';
import '../handler/quote/quote.dart';

import '../../infrastructure/web/handler.dart';
import '../../infrastructure/web/router.dart';

Router createRouter(AuthorHandler authorHandler, BookHandler bookHandler, QuoteHandler quoteHandler) {
  Router router = Router(resourceNotFound);

  router.registerRoute(r"/{anything}", "OPTIONS", options);

  router.registerRoute(r"/authors", "POST", authorHandler.persist);
  router.registerRoute(r"/authors/{authorId}", "GET", authorHandler.find);
  router.registerRoute(r"/authors/{authorId}", "PUT", authorHandler.update);
  router.registerRoute(r"/authors/{authorId}", "DELETE", authorHandler.delete);
  router.registerRoute(r"/authors", "GET", authorHandler.search);
  router.registerRoute(r"/authors/{authorId}/events", "GET", authorHandler.listEvents);

  router.registerRoute(r"/authors/{authorId}/books", "POST", bookHandler.persist);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "GET", bookHandler.find);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "PUT", bookHandler.update);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "DELETE", bookHandler.delete);
  router.registerRoute(r"/authors/{authorId}/books", "GET", bookHandler.listByAuthor);
  router.registerRoute(r"/books", "GET", bookHandler.search);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/events", "GET", bookHandler.listEvents);

  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "POST", quoteHandler.persist);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "GET", quoteHandler.find);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "PUT", quoteHandler.update);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "DELETE", quoteHandler.delete);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "GET", quoteHandler.listByBook);
  router.registerRoute(r"/quotes", "GET", quoteHandler.search);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events", "GET", quoteHandler.listEvents);

  return router;
}
