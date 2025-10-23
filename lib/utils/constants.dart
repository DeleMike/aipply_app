import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';
import 'dimensions.dart';

const String kAppName = 'Drazex';

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
    required String content,
    Color? color,
    int timeInSec = 4,
    bool isSelectable = false,
  }) {
    final snackbar = SnackBar(
      backgroundColor: color ?? AppColors.kPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmallRadius)),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: timeInSec),
      showCloseIcon: true,
      content: Padding(
        padding: const EdgeInsets.all(kPaddingS),
        child: isSelectable
            ? SelectableText(
                content,
                style: const TextStyle(color: AppColors.kWhite, fontSize: 14),
              )
            : Text(
                content,
                style: const TextStyle(color: AppColors.kWhite, fontSize: 14),
                //Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite),
              ),
      ),
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
