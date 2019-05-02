import 'dart:async';
import 'dart:io';

import './domain/author/model.dart';
import './domain/author/service.dart';
import './domain/author/event.dart';
import './domain/author/repository.dart';

import './domain/quote/model.dart';
import './domain/quote/service.dart';
import './domain/quote/event.dart';
import './domain/quote/repository.dart';

import './domain/book/model.dart';
import './domain/book/service.dart';
import './domain/book/event.dart';
import './domain/book/repository.dart';

import 'tools/elasticsearch/store.dart';

import 'package:postgres/postgres.dart';

import 'config/config.dart';

import 'package:logging/logging.dart';

DateTime utcNow() => DateTime.now().toUtc();

var author1Desc =
    """[From Wikipedia] William Shakespeare (bapt. 26 April 1564 – 23 April 1616) was an English poet, playwright and actor, widely regarded as the greatest writer in the English language and the world's greatest dramatist. He is often called England's national poet and the "Bard of Avon". His extant works, including collaborations, consist of approximately 39 plays, 154 sonnets, two long narrative poems, and a few other verses, some of uncertain authorship. His plays have been translated into every major living language and are performed more often than those of any other playwright.
Shakespeare was born and raised in Stratford-upon-Avon, Warwickshire. At the age of 18, he married Anne Hathaway, with whom he had three children: Susanna and twins Hamnet and Judith. Sometime between 1585 and 1592, he began a successful career in London as an actor, writer, and part-owner of a playing company called the Lord Chamberlain's Men, later known as the King's Men. At age 49 (around 1613), he appears to have retired to Stratford, where he died three years later. Few records of Shakespeare's private life survive; this has stimulated considerable speculation about such matters as his physical appearance, his sexuality, his religious beliefs, and whether the works attributed to him were written by others. Such theories are often criticised for failing to adequately note that few records survive of most commoners of the period.""";

var author1 =
    Author(null, "William Shakespeare", author1Desc, utcNow(), utcNow());

var author2Desc =
    """[From Wikipedia] Johann Wolfgang von Goethe (28 August 1749 – 22 March 1832) was a German writer and statesman. His works include four novels; epic and lyric poetry; prose and verse dramas; memoirs; an autobiography; literary and aesthetic criticism; and treatises on botany, anatomy, and colour. In addition, there are numerous literary and scientific fragments, more than 10,000 letters, and nearly 3,000 drawings by him extant.
A literary celebrity by the age of 25, Goethe was ennobled by the Duke of Saxe-Weimar, Karl August, in 1782 after taking up residence there in November 1775 following the success of his first novel, The Sorrows of Young Werther (1774). He was an early participant in the Sturm und Drang literary movement. During his first ten years in Weimar, Goethe was a member of the Duke's privy council, sat on the war and highway commissions, oversaw the reopening of silver mines in nearby Ilmenau, and implemented a series of administrative reforms at the University of Jena. He also contributed to the planning of Weimar's botanical park and the rebuilding of its Ducal Palace, which in 1998 were together designated a UNESCO World Heritage site under the name Classical Weimar.""";

var author2 =
    Author(null, "Johann Wolfgang von Goethe", author2Desc, utcNow(), utcNow());

var author3Desc =
    """[From Wikipedia] Adam Bernard Mickiewicz (24 December 1798 – 26 November 1855) was a Polish poet, dramatist, essayist, publicist, translator, professor of Slavic literature, and political activist. He is regarded as national poet in Poland, Lithuania and Belarus. A principal figure in Polish Romanticism, he is counted as one of Poland's "Three Bards" ("Trzej Wieszcze") and is widely regarded as Poland's greatest poet. He is also considered one of the greatest Slavic and European poets and has been dubbed a "Slavic bard". A leading Romantic dramatist, he has been compared in Poland and Europe to Byron and Goethe.
He is known chiefly for the poetic drama Dziady (Forefathers' Eve) and the national epic poem Pan Tadeusz. His other influential works include Konrad Wallenrod and Grażyna. All these served as inspiration for uprisings against the three imperial powers that had partitioned the Polish-Lithuanian Commonwealth out of existence.""";

var author3 =
    Author(null, "Adam Bernard Mickiewicz", author3Desc, utcNow(), utcNow());

var book1Desc =
    """[From Wikipedia] The Tragedy of Hamlet, Prince of Denmark, often shortened to Hamlet, is a tragedy written by William Shakespeare at an uncertain date between 1599 and 1602. Set in Denmark, the play dramatises the revenge Prince Hamlet is called to wreak upon his uncle, Claudius, by the ghost of Hamlet's father, King Hamlet. Claudius had murdered his own brother and seized the throne, also marrying his deceased brother's widow.
Hamlet is Shakespeare's longest play, and is considered among the most powerful and influential works of world literature, with a story capable of "seemingly endless retelling and adaptation by others". It was one of Shakespeare's most popular works during his lifetime, and still ranks among his most performed, topping the performance list of the Royal Shakespeare Company and its predecessors in Stratford-upon-Avon since 1879. It has inspired many other writers—from Johann Wolfgang von Goethe and Charles Dickens to James Joyce and Iris Murdoch—and has been described as "the world's most filmed story after Cinderella".""";

var book1 = Book(null, "Hamlet", book1Desc, author1.id, utcNow(), utcNow());

var book2Desc =
    """[From Wikipedia] Macbeth (Medieval Gaelic: Mac Bethad mac Findlaích; Modern Gaelic: MacBheatha mac Fhionnlaigh; nicknamed Rí Deircc, "the Red King"; c. 1005 – 15 August 1057) was King of Scots from 1040 until his death. He was titled King of Alba during his life, and ruled over only a portion of present-day Scotland.""";

var book2 = Book(null, "Macbeth, King of Scotland", book2Desc, author1.id,
    utcNow(), utcNow());

var book3Desc =
    """[From Wikipedia] The Tempest is a play by William Shakespeare, believed to have been written in 1610–1611, and thought by many critics to be the last play that Shakespeare wrote alone. It is set on a remote island, where the sorcerer Prospero, rightful Duke of Milan, plots to restore his daughter Miranda to her rightful place using illusion and skillful manipulation. He conjures up a storm, the eponymous tempest, to cause his usurping brother Antonio and the complicit King Alonso of Naples to believe they are shipwrecked and marooned on the island. There, his machinations bring about the revelation of Antonio's lowly nature, the redemption of the King, and the marriage of Miranda to Alonso's son, Ferdinand.""";

var book3 =
    Book(null, "The Tempest", book3Desc, author1.id, utcNow(), utcNow());

var book4Desc =
    """[From Wikipedia] A Midsummer Night's Dream is a comedy written by William Shakespeare in 1595/96. It portrays the events surrounding the marriage of Theseus, the Duke of Athens, to Hippolyta (the former queen of the Amazons). These include the adventures of four young Athenian lovers and a group of six amateur actors (the mechanicals) who are controlled and manipulated by the fairies who inhabit the forest in which most of the play is set. The play is one of Shakespeare's most popular works for the stage and is widely performed across the world.""";

var book4 = Book(null, "A Midsummer Night's Dream", book4Desc, author1.id,
    utcNow(), utcNow());

var quote1Text = """Where the bee sucks, there suck I;
In a cowslip's bell I lie;
There I couch when owls do cry.
On the bat's back I do fly
After summer merrily.
Merrily, merrily, shall I live now,
Under the blossom that hangs on the bough.""";

var quote1 = Quote(null, quote1Text, author1.id, book3.id, utcNow(), utcNow());

var quote2Text = """O, wonder!
How many goodly creatures are there here!
How beauteous mankind is! O brave new world,
That has such people in't!""";

var quote2 = Quote(null, quote2Text, author1.id, book3.id, utcNow(), utcNow());

var quote3Text = """Though with their high wrongs I am struck to the quick,
Yet, with my nobler reason 'gainst my fury
Do I take part; the rarer action is
In virtue than in vengeance.""";

var quote3 = Quote(null, quote3Text, author1.id, book3.id, utcNow(), utcNow());

var quote4Text = """Pray you, tread softly, that the blind mole may not
Hear a foot fall; we now are near his cell.""";

var quote4 = Quote(null, quote4Text, author1.id, book3.id, utcNow(), utcNow());

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  String configLocation = args[0];
  Config config = await readConfig(configLocation);

  var dbConfig = config.postgres;

  PostgreSQLConnection connection = PostgreSQLConnection(
      dbConfig.host, dbConfig.port, dbConfig.database,
      username: dbConfig.user, password: dbConfig.password);
  await connection.open();

  AuthorRepository authorRepository = AuthorRepository(connection);
  BookRepository bookRepository = BookRepository(connection);
  QuoteRepository quoteRepository = QuoteRepository(connection);

  HttpClient client = HttpClient();

  var esConfig = config.elasticsearch;

  var authorEsStore = ESStore<AuthorEvent>(
      client, esConfig.host, esConfig.port, esConfig.authorsIndex);

  var bookEsStore = ESStore<BookEvent>(
      client, esConfig.host, esConfig.port, esConfig.booksIndex);

  var quoteEsStore = ESStore<QuoteEvent>(
      client, esConfig.host, esConfig.port, esConfig.quotesIndex);

  var authorEventRepository = AuthorEventRepository(authorEsStore);
  var bookEventRepository = BookEventRepository(bookEsStore);
  var quoteEventRepository = QuoteEventRepository(quoteEsStore);

  var authorService = AuthorService(
      authorRepository,
      authorEventRepository,
      bookRepository,
      bookEventRepository,
      quoteRepository,
      quoteEventRepository);
  var bookService = BookService(bookRepository, bookEventRepository,
      quoteRepository, quoteEventRepository);
  var quoteService = QuoteService(quoteRepository, quoteEventRepository);

  [author1, author2, author3]
      .forEach((author) async => await authorService.save(author));
  [book1, book2, book3, book4]
      .forEach((book) async => await bookService.save(book));
  [quote1, quote2, quote3, quote4]
      .forEach((quote) async => await quoteService.save(quote));
}
