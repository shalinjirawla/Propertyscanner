import 'dart:developer';

import 'package:flutter/foundation.dart';

var isLog = true;

class Console {
  static void Log({var title, var message}) {
    if (kDebugMode && isLog) {
      log('$title :- $message');
    }
  }
}
