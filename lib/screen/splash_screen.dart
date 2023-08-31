import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignupwithfirebase/main.dart';
import 'package:loginsignupwithfirebase/screen/dashoard_screen.dart';
import 'package:loginsignupwithfirebase/screen/signin_screen.dart';

import '../config/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      if (getStorage!.read("isLogin") == true) {
        Get.offAll(() => const DashBoardScreen());
      } else {
        Get.offAll(() => const SignInScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppImages.logo,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
