import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_colors.dart';
import '../utils/dimensions.dart';
import 'outlined_input_border.dart';

class GeneralInputField extends ConsumerWidget {
  const GeneralInputField({
    super.key,
    required this.widgetKey,
    required this.fieldName,
    required this.hintText,
    required this.validator,
    required this.keyValueForDict,
    required this.userData,
    required this.keyboardType,
    required this.errorProvider,
    required this.enabled,
    required this.actionWhenOnChangedisPressed,
    required this.textEditingController,
    required this.focusNode,

    this.nextFocusNode,
    this.minLines,
    this.maxLines,
    this.initialValue,
    this.suffixIcon,
    this.prefixIcon,
    this.widgetAutofillHints,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.dateWillPeekIntoFuture = false,
    this.onDatePicked,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
    this.needsFieldName = true,
    this.hasSelectedDateProvider,
    this.hasSelectedTimeProvider,
    this.isDOB = false,
    this.expands = false,
    this.textInputAction = TextInputAction.newline,
  });

  final String widgetKey;
  final String fieldName;
  final String hintText;
  final String? Function(String?)? validator;
  final String keyValueForDict;
  final Map<String, dynamic> userData;
  final TextInputType keyboardType;
  final AutoDisposeStateProvider<bool>? errorProvider;
  final bool enabled;
  final Function(String?)? actionWhenOnChangedisPressed;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final int? minLines;
  final int? maxLines;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final Iterable<String>? widgetAutofillHints;
  final bool isDatePicker;
  final bool dateWillPeekIntoFuture;
  final bool isTimePicker;
  final bool isDOB;
  final bool expands;

  final TextCapitalization textCapitalization;
  final ValueChanged<DateTime>? onDatePicked;
  final bool isPassword;
  final bool needsFieldName;
  final AutoDisposeStateProvider<bool>? hasSelectedDateProvider;
  final AutoDisposeStateProvider<bool>? hasSelectedTimeProvider;

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasError = (errorProvider == null) ? false : ref.watch(errorProvider!);

    return TextFormField(
      key: ValueKey(widgetKey),
      enabled: enabled,
      autofillHints: widgetAutofillHints,
      controller: textEditingController,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.top,
      minLines: minLines,
      maxLines: maxLines,
      expands: expands,

      initialValue: initialValue,
      obscureText: isPassword,
      decoration: InputDecoration(
        helperMaxLines: 2,
        errorMaxLines: 3,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.kTextSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        floatingLabelStyle: const TextStyle(color: AppColors.kGray600),
        enabledBorder: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(kSmallRadius),
          borderSide: const BorderSide(color: AppColors.kGray300, width: 1.5),
        ),
        focusedBorder: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(kSmallRadius),
          borderSide: const BorderSide(color: AppColors.kPrimary, width: 1.5),
        ),
        errorBorder: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(kSmallRadius),
          borderSide: const BorderSide(color: AppColors.kError, width: 1),
        ),
        disabledBorder: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(kSmallRadius),
          borderSide: const BorderSide(color: AppColors.kGray300, width: 1),
        ),
        focusedErrorBorder: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(kSmallRadius),
          borderSide: const BorderSide(color: AppColors.kError, width: 1),
        ),
        errorStyle: const TextStyle(color: AppColors.kError),
        filled: false,
        fillColor: AppColors.kGray300,
      ),
      cursorColor: AppColors.kPrimary,
      textCapitalization: textCapitalization,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: hasError
            ? AppColors.kError
            : enabled
            ? AppColors.kTextOnAccent
            : AppColors.kGray600,
      ),
      validator: validator,

      onChanged: (value) {
        if (actionWhenOnChangedisPressed != null) {
          actionWhenOnChangedisPressed!(value);
        }
      },
      onSaved: (value) {
        userData[keyValueForDict] = value;
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
