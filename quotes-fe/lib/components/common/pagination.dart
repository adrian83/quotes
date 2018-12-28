import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/common/page.dart';

abstract class PageSwitcher {
  void change(int pageNumber);
}

class PageLink {
  String _label;
  bool _disabled, _current;
  int _page;

  PageLink(this._label, this._disabled, this._current, this._page);

  String get label => this._label;
  bool get disabled => this._disabled;
  bool get current => this._current;
  int get page => this._page;
}

@Component(
    selector: 'pagination',
    templateUrl: 'pagination.template.html',
    directives: const [formDirectives, coreDirectives])
class Pagination implements OnActivate {
  static final Logger logger = Logger('Pagination');

  List<PageLink> _links = [];
  PageInfo _page;

  @Input()
  void set page(PageInfo page) {
    _page = page;
    _links = _createLinks(page);
  }

  @Input()
  PageSwitcher switcher;

  void onActivate(_, RouterState state) {
    logger.info("Pagination initialized.");
  }

  List<PageLink> get links => _links;

  void changePage(int pageNumber) {
    var pages = _pagesCount(_page);
    logger.info("");
    if (pageNumber >= 0 && pageNumber < pages) {
      switcher.change(pageNumber);
    }
  }

  int _pagesCount(PageInfo page) {
    var count = page == null ? 0 : (page.total / page.limit);
    return count.isNaN ? 0 : count.ceil();
  }

  int _currentPage(PageInfo page) {
    var current = page == null ? 0 : (page.offset / page.limit);
    return current.isNaN ? 0 : current.ceil();
  }

  List<PageLink> _createLinks(PageInfo page) {
    if (page == null) {
      return [];
    }

    var pages = _pagesCount(page);
    logger.info("total: ${page.total}, pages: $pages");

    if (pages < 2) {
      return [];
    }

    var current = _currentPage(page);
    var pageZero = current == 0;
    var lastPage = current == (pages - 1);
    var zeroPages = pages == 0;

    List<PageLink> links = [];

    links.add(PageLink("<<", pageZero || zeroPages, false, current - 1));

    var show = 6;

    for (var index = 0; index < pages; index++) {
      var offset = (pages - 1) - current;

      var addFirst = current > show;
      if (index == 0 && addFirst) {
        links.add(PageLink("${index + 1}", false, current == index, index));
        continue;
      }

      var addLowerDots = current > show;
      if (index == 1 && addLowerDots) {
        links.add(PageLink("...", true, false, -1));
        continue;
      }

      var addUpperDots = offset > show;
      if (index == (pages - 2) && addUpperDots) {
        links.add(PageLink("...", true, false, -1));
        continue;
      }

      var addLast = offset > show;
      if (index == (pages - 1) && addLast) {
        links.add(PageLink("${index + 1}", false, current == index, index));
        continue;
      }

      var minShow = current -
          (addFirst ? (addLowerDots ? (show - 2) : (show - 1)) : show) -
          (show - (offset > show ? show : offset));
      var maxShow = current +
          (addLast ? (addUpperDots ? (show - 2) : (show - 1)) : show) +
          (show - (current > show ? show : current));

      if (index < minShow) continue;
      if (index > maxShow) continue;

      links.add(PageLink("${index + 1}", false, current == index, index));
    }

    links.add(PageLink(">>", lastPage || zeroPages, false, current + 1));

    return links;
  }
}
