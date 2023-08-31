import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignupwithfirebase/config/app_color.dart';
import 'package:loginsignupwithfirebase/main.dart';
import 'package:loginsignupwithfirebase/widget/common_loading_dialog.dart';
import 'package:loginsignupwithfirebase/widget/common_toast.dart';
import 'package:pinput/pinput.dart';

import '../config/app_images.dart';
import '../config/text_style.dart';
import '../controller/loginController.dart';
import '../services/firebase_crud.dart';
import '../widget/custom_button.dart';
import 'dashoard_screen.dart';

class PinputScreen extends StatefulWidget {
  final bool isSignup;
  final String? phone;
  const PinputScreen({super.key, this.isSignup = false, this.phone});

  @override
  State<PinputScreen> createState() => _PinputScreenState();
}

class _PinputScreenState extends State<PinputScreen> {
  LoginController loginController = Get.put(LoginController());
  TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  num second = 60;
  bool resend = false;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second > 1) {
        second--;
      } else {
        resend = true;
        timer.cancel();
      }
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Image.asset(
                  AppImages.logo,
                  width: Get.width,
                  height: 400,
                  fit: BoxFit.fill,
                ),
                const Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text(
                    "Verification Code",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Pinput(
                errorPinTheme: const PinTheme(textStyle: TextStyle(color: Colors.red)),
                showCursor: true,
                enabled: true,
                keyboardType: TextInputType.number,
                length: 6,
                focusNode: focusNode,
                controller: otpController,
                closeKeyboardWhenCompleted: true,
                disabledPinTheme: PinTheme(
                  padding: EdgeInsets.zero,
                  height: 50,
                  width: 50,
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                ),
                defaultPinTheme: PinTheme(
                  padding: EdgeInsets.zero,
                  height: 50,
                  width: 50,
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                ),
                submittedPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: TextStyle(color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (resend == true) {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        auth.verifyPhoneNumber(
                            phoneNumber: "+91${widget.phone}",
                            timeout: const Duration(seconds: 60),
                            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                              debugPrint("complete == $phoneAuthCredential");
                            },
                            verificationFailed: (failed) {},
                            codeSent: (code, token) {
                              loginController.verificationCodeforSignup.value = code;
                              debugPrint("code == $token");
                              setState(() {
                                resend = false;
                                second = 60;
                              });
                              debugPrint("resend");

                              Timer.periodic(Duration(seconds: 1), (timer) {
                                if (second > 1) {
                                  second--;
                                } else {
                                  resend = true;
                                  timer.cancel();
                                }
                                setState(() {});
                              });
                              setState(() {});
                            },
                            codeAutoRetrievalTimeout: (timeout) {});
                      }
                    },
                    child: Text(
                      "Resend Code",
                      style: resend == true
                          ? AppTextStyle.font14.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    AppColors.primaryColor,
                                    AppColors.primaryColor1
                                    //add more color here.
                                  ],
                                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)))
                          : AppTextStyle.font14.copyWith(color: Colors.grey),
                    ),
                  ),
                  if (resend == false) Text("  (Resend code in ${second} second)")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 40),
              child: GestureDetector(
                onTap: () async {
                  if (otpController.text.isEmpty) {
                    toastMessage("Please Enter OTP", AppColors.greenColor);
                  } else if (otpController.text.length < 6) {
                    toastMessage("Please Enter valid OTP", AppColors.greenColor);
                  } else {
                    showLoadingDialog();
                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId:
                              widget.isSignup == false ? loginController.verificationCodeforLogin.value : loginController.verificationCodeforSignup.value,
                          smsCode: otpController.text);
                      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                      debugPrint("=======>${userCredential.user}");
                      if (userCredential.user != null) {
                        await FirebaseCrud.addUserData(
                          number: "+91 ${widget.phone}",
                        ).whenComplete(() async {
                          await getStorage!.write("isLogin", true);
                          hideLoadingDialog();
                          Get.to(() => const DashBoardScreen());
                        });
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-verification-code') {
                        debugPrint("code invalid${e.message}");
                      } else {
                        debugPrint("other ${e.message}");
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                },
                child: customContainer(child: widget.isSignup == false ? "Login" : "Signup"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
