import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';

const String kAppName = 'AIpply';

final kCovertToCurrencyForm = NumberFormat("#,##0.00", "en_US");

final kCovertToReadableForm = NumberFormat("#,##0", "en_US");

/// messenger key
final messengerKey = GlobalKey<ScaffoldMessengerState>();

/// navigator key
final navigatorKey = GlobalKey<NavigatorState>();

const networkTimeout = 30;

const String kHeadingFont = 'Poppins';
const String kBodyFont = 'Lato';

const nA = 'N/A';

void showToast(
  String message, {
  wantsLongText = false,
  wantsCenterMsg = false,
  textShouldBeInProd = false,
}) {
  if (kDebugMode) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: wantsLongText ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: wantsCenterMsg ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.kTextPrimary,
      textColor: AppColors.kWhite,
      fontSize: 16.0,
    );
  } else if (!kDebugMode && textShouldBeInProd) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: wantsLongText ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: wantsCenterMsg ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.kTextPrimary,
      textColor: AppColors.kWhite,
      fontSize: 16.0,
    );
  }
}

class SnackBarService {
  /// show a snackbar
  static void showSnackBar({
    required BuildContext context, // 1. We must pass the context
    required String content,
    Color? color,
    // Removed timeInSec and isSelectable, as they aren't in your new example
  }) {
    // 2. Create the simple SnackBar, just like your example
    final snackbar = SnackBar(
      backgroundColor: color ?? AppColors.kPrimary, // Use the color, or a default
      content: Text(
        content,
        // 3. Use the Theme from the context, as in your example
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.kWhite),
      ),
    );

    // 4. Use the context to get the ScaffoldMessenger
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // Kept this handy feature from your old code
      ..showSnackBar(snackbar);
  }
}
