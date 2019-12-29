import 'package:angular/angular.dart';

import '../domain/common/router.dart';

@Component(
  selector: 'info',
  templateUrl: 'info.template.html',
  providers: [ClassProvider(QuotesRouter)],
  directives: [coreDirectives],
)
class InfoComponent {
  final QuotesRouter _router;

  InfoComponent(this._router);

  void showSearch() => _router.showSearch();
}
