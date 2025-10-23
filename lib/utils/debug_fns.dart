import 'package:flutter/foundation.dart';

/// print messages to the console only in debug mode
///
/// [title] - incase you want to add the module where this print function is triggered
///
/// [message] - the message to print out
void printOut(Object? message, [bool turnOn = true, String title = '']) {
  if (turnOn) {
    if (kDebugMode) {
      if (title.isNotEmpty) {
        debugPrint('$title: $message');
      } else {
        debugPrint(message.toString());
      }
    }
  }
}
