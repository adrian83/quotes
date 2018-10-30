import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/common/page.dart';

class PageLink {
  String _label;
  bool _disabled;
  bool _current;
  int _page;

  PageLink(this._label, this._disabled, this._current, this._page);

  String get label => this._label;
  bool get disabled => this._disabled;
  bool get current => this._current;
  int get page => this._page;
}

abstract class PageSwitcher {
  void change(int pageNumber);
}

@Component(
    selector: 'pagination',
    templateUrl: 'pagination.template.html',
    directives: const [formDirectives, coreDirectives])
class Pagination implements OnInit {
  static final Logger logger = new Logger('Pagination');

  @Input()
  PageInfo page;
  @Input()
  PageSwitcher switcher;

  Future<Null> ngOnInit() async {
    logger.info("Pagination initialized. Switcher: $switcher, page: $page");
  }

  void changePage(int page) {
    var pages = _pagesCount();
    logger.info("Pages: $pages, page: $page");
    if (page >= 0 && page < pages) {
      switcher.change(page);
    }
  }

  int _pagesCount() {
    var count = this.page == null ? 0 : (page.total / page.limit);
    return count.isNaN ? 0 : count.ceil();
  }

  int _currentPage() {
    var current = this.page == null ? 0 : (page.offset / page.limit);
    return current.isNaN ? 0 : current.ceil();
  }

  List<PageLink> get links {
    if (this.page == null) {
      return [];
    }

    var pages = _pagesCount();

    if (pages < 1) {
      return [];
    }

    var current = _currentPage();
    var pageZero = current == 0;
    var lastPage = current == (pages - 1);
    var zeroPages = pages == 0;

    List<PageLink> links = [];
    links.add(PageLink("<<", pageZero || zeroPages, false, current - 1));

    for (var i = 0; i < pages; i++) {
      links.add(PageLink("${i + 1}", false, current == i, i));
    }

    links.add(PageLink(">>", lastPage || zeroPages, false, current + 1));

    return links;
  }
}
