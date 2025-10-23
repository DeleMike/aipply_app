import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/dimensions.dart';

/// A customizable, reusable elevated button for the Neep app.
///
/// This button provides flexibility with configurable colors, height, and
/// border options. It is designed to fit the Neep app's theme, with an
/// elevated appearance and custom color options for various app scenarios.
///
/// Example usage:
///
/// ```dart
/// GeneralElevatedButton(
///   onPressed: () {
///     // Button action
///   },
///   child: Text('Click Me'),
///   buttonColor: Colors.blue,
///   borderColor: Colors.blueAccent,
///   buttonHeight: 50,
/// );
/// ```
///
/// All parameters except [onPressed], [child], and [buttonColor] are optional.
///
/// * [onPressed]: Callback when the button is pressed.
/// * [child]: Widget to display as the button's label.
/// * [buttonColor]: Color of the button's background.
/// * [buttonHeight]: Optional height of the button.
/// * [borderColor]: Optional color of the button's border.
class GeneralElevatedButton extends StatelessWidget {
  /// Callback function called when the button is pressed.
  final VoidCallback? onPressed;

  /// Widget to display inside the button, typically a [Text] or [Icon].
  final Widget child;

  /// Background color of the button.
  final Color buttonColor;

  /// Height of the button. If null, defaults to 50.
  final double? buttonHeight;

  final double? buttonWidth;

  /// Border color for the button's outline. If null, defaults to [AppColors.kGray200].
  final Color? borderColor;

  final double? elevation;

  final double? borderRadius;

  /// Creates an instance of [GeneralElevatedButton].
  ///
  /// [onPressed], [child], and [buttonColor] are required parameters.
  const GeneralElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.child,
    this.buttonHeight,
    this.buttonWidth,
    this.borderColor,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        elevation: elevation,
        minimumSize: Size(buttonWidth ?? kScreenWidth(context), buttonHeight ?? 50),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? AppColors.kTransparent),
          borderRadius: BorderRadius.circular(borderRadius ?? kLargeRadius),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
