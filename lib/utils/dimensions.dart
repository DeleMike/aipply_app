import 'package:flutter/material.dart';

const double kButtonHeight = 64.0;
const double kButtonRadius = 8.0;
const double kCardElevation = 0.0;

const double kDialogRadius = 0.0;
const double kLargeRadius = 32.0;

const double kMediumRadius = 16.0;
const double kSmallRadius = 12.0;
const double kVerySmallRadius = 8.0;

const double kPaddingL = 24.0;
const double kPaddingM = 16.0;
const double kPaddingS = 12.0;

/// Get screen orientation
Orientation kGetOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation;
}

/// Get screen height
double kScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Get screen width
double kScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
