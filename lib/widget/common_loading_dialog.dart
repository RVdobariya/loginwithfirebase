import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';

void showLoadingDialog() {
  Future.delayed(
    Duration.zero,
    () {
      Get.dialog(
        Center(
          child: Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    },
  );
}

void hideLoadingDialog({bool istrue = false}) {
  Get.back(closeOverlays: istrue);
}
