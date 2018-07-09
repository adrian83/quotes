

import '../domain/quote.dart';

class QuotesService {


	List<Quote> findQuotes() {
		return [new Quote(1, "quote 1"), new Quote(2, "quote 2")];
	}


}

