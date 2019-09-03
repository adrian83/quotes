import 'dart:io';

import 'package:logging/logging.dart';

import 'common.dart';
import 'common/form.dart';


typedef HandlerV2<HttpRequest, PathParams, UrlParams> = void Function(HttpRequest request, PathParams pathParams, UrlParams urlParams);