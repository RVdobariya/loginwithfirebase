import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignupwithfirebase/config/app_color.dart';
import 'package:loginsignupwithfirebase/config/text_style.dart';

Widget customContainer({String? child}) {
  return Container(
    width: Get.width,
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor1,
          ],
        )),
    child: Text(
      child!,
      style: AppTextStyle.medium.copyWith(fontWeight: FontWeight.w600, color: AppColors.whiteColor),
    ),
  );
}
