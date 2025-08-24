import 'package:flutter/foundation.dart';

void debugPrintWarning(String location, String message) {
  debugPrint('\x1B[33m [$location]: $message \x1B[0m');
}

void debugPrintError(String location, String message) {
  debugPrint('\x1B[31m [$location]: $message \x1B[0m');
}

void debugPrintSuccess(String location, String message) {
  debugPrint('\x1B[32m [$location]: $message \x1B[0m');
}

void debugPrintInfo(String location, String message) {
  debugPrint('\x1B[37m [$location]: $message \x1B[0m');
}

void debugPrintSpecial(String location, String message) {
  debugPrint('\x1B[36m [$location]: $message \x1B[0m');
}
