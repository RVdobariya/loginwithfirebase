import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginsignupwithfirebase/widget/validation_helper.dart';

import '../config/app_color.dart';
import '../config/text_style.dart';

class CommonTexField extends StatelessWidget {
  final TextEditingController controller;
  final String? validationMessage;
  final Function(String)? onChange;
  final bool? needValidation;
  final bool? isEmailValidator;
  final bool isPasswordValidator;
  final bool isConfPassValidator;
  final bool isCardValidator;
  final bool isCVCValidator;
  final bool isExpiryYearValidator;
  final bool isExpiryMonthValidator;
  final bool isPhoneNumberValidator;
  final bool isPinCodeValidator;
  final bool isExpiryDateValidator;
  final String hintText;
  final Widget? prefix;
  final Widget? sufix;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillClr;
  final Color? enableBorder;
  final Color? hintClr;
  final Color? focusBorder;
  final Color? border;
  final Color? cursorClr;
  final Color? fontClr;
  final bool? obscure;
  final double? height;
  final double? hintSize;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final bool? readOnly;
  final int? maxlength;

  CommonTexField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefix,
      this.sufix,
      this.contentPadding,
      this.fillClr,
      this.enableBorder,
      this.hintClr,
      this.focusBorder,
      this.border,
      this.cursorClr,
      this.obscure,
      this.height,
      this.fontClr,
      this.hintSize,
      this.validationMessage,
      this.readOnly = false,
      this.needValidation = false,
      this.isEmailValidator = false,
      this.isPasswordValidator = false,
      this.isConfPassValidator = false,
      this.isCardValidator = false,
      this.isCVCValidator = false,
      this.isExpiryYearValidator = false,
      this.isExpiryMonthValidator = false,
      this.isPhoneNumberValidator = false,
      this.isPinCodeValidator = false,
      this.onChange,
      this.textInputType,
      this.inputFormatters,
      this.isExpiryDateValidator = false,
      this.autoFocus = false,
      this.focusNode,
      this.maxlength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          maxLength: maxlength,
          readOnly: readOnly!,
          focusNode: focusNode,
          autofocus: autoFocus!,
          obscureText: obscure ?? false,
          cursorColor: cursorClr ?? AppColors.blackColor,
          keyboardType: textInputType ?? TextInputType.text,
          inputFormatters: inputFormatters ?? [],
          controller: controller,
          style: AppTextStyle.font14.copyWith(fontWeight: FontWeight.w400, color: fontClr ?? AppColors.blackColor),
          onChanged: onChange,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: sufix,
            prefixIcon: prefix,
            contentPadding: contentPadding ?? const EdgeInsets.only(top: 16, left: 14, right: 14),
            hintText: hintText,
            hintStyle: AppTextStyle.regular.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: hintSize ?? 14,
              color: hintClr ?? AppColors.greyTextColor,
            ),
            fillColor: AppColors.whiteColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(
                color: Colors.transparent ?? AppColors.dividerColor,
              ),
            ),
            disabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          validator: needValidation!
              ? (v) {
                  return TextFieldValidation.validation(
                      isConfPassValidator: isConfPassValidator,
                      isEmailValidator: isEmailValidator!,
                      isPasswordValidator: isPasswordValidator,
                      isPhoneNumberValidator: isPhoneNumberValidator,
                      isPinCodeValidator: isPinCodeValidator,
                      isCardValidator: isCardValidator,
                      isCVCValidator: isCVCValidator,
                      isExpiryDateValidator: isExpiryDateValidator,
                      message: validationMessage,
                      value: v!.trim());
                }
              : null,
        ),
      ],
    );
  }
}
