import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import '../domain/common/exception.dart';
import 'common/exception.dart';
import 'common/form.dart';
import 'response.dart';



  void handleErrors(Object ex, HttpRequest request) {
    //logger.info("Error occured. Error: $ex");
    if (ex is SaveFailedException) {
      serverError("cannot save entity", request);
    } else if (ex is UpdateFailedException) {
      serverError("cannot update entity", request);
    } else if (ex is FindFailedException) {
      notFound(request);
    } else if (ex is InvalidDataException) {
      badRequest(ex.errors, request);
    } else {
      serverError("unknown error ${ex}", request);
    }
  }