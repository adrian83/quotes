import 'dart:io';

import 'response.dart';
import 'common/form.dart';


typedef Handler = void Function(HttpRequest request, PathParams pathParams, UrlParams urlParams);

void options(HttpRequest req, PathParams pathParams, UrlParams urlParams) => Future.sync(() => ok(null, req));

void resourceNotFound(HttpRequest req, PathParams pathParams, UrlParams urlParams) => Future.sync(() => notFound(req));

