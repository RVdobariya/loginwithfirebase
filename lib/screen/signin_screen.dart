import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loginsignupwithfirebase/controller/loginController.dart';
import 'package:loginsignupwithfirebase/screen/pinput_screen.dart';
import 'package:loginsignupwithfirebase/screen/signup_screen.dart';
import 'package:loginsignupwithfirebase/widget/common_toast.dart';
import 'package:loginsignupwithfirebase/widget/custom_button.dart';

import '../config/app_color.dart';
import '../config/app_images.dart';
import '../config/text_style.dart';
import '../services/firebase_crud.dart';
import '../widget/common_loading_dialog.dart';
import '../widget/common_textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginController loginController = Get.put(LoginController());
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? customerAge;

  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readUserData();

  @override
  void initState() {
    // TODO: implement initState
    collectionReference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
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
                      child: Text(
                        "Login Now",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                      bottom: 10,
                      left: 0,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.white),
                      child: CountryCodePicker(
                        initialSelection: "IN",
                        showFlagDialog: true,
                        showFlagMain: true,
                        showFlag: true,
                        onChanged: (v) {},
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        child: const VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                          width: 5,
                          indent: 12,
                          endIndent: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CommonTexField(
                        border: Colors.transparent,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        controller: phone,
                        hintText: 'Enter mobile number',
                        textInputType: TextInputType.number,
                        needValidation: true,
                        isPhoneNumberValidator: true,
                        validationMessage: 'Mobile number',
                        cursorClr: AppColors.hintColor,
                        hintClr: AppColors.hintColor,
                        focusBorder: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                StreamBuilder(
                    stream: collectionReference,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!.docs.any((element) => element['user_number'].toString() == "+91 ${phone.text}");

                                debugPrint("==========$data");
                                if (data != true) {
                                  toastMessage("User Dose Not Found", AppColors.primaryColor);
                                  // Get.snackbar("Warning", "User Dose Not Found");
                                } else {
                                  debugPrint("mobiule number == +91 ${phone.text}");
                                  showLoadingDialog();
                                  FirebaseAuth auth = FirebaseAuth.instance;

                                  auth.verifyPhoneNumber(
                                      phoneNumber: "+91${phone.text}",
                                      timeout: const Duration(seconds: 60),
                                      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                                        debugPrint("complete == $phoneAuthCredential");
                                      },
                                      verificationFailed: (failed) {
                                        debugPrint("error == ${failed}");
                                      },
                                      codeSent: (code, token) {
                                        loginController.verificationCodeforLogin.value = code;
                                        debugPrint("code == $token");
                                        hideLoadingDialog();
                                        Get.to(() => PinputScreen(
                                              phone: phone.text,
                                            ));
                                      },
                                      codeAutoRetrievalTimeout: (timeout) {});
                                }
                              } else {
                                debugPrint("mobiule number == +91 ${phone.text}");
                                showLoadingDialog();
                                FirebaseAuth auth = FirebaseAuth.instance;
                                auth.verifyPhoneNumber(
                                    phoneNumber: "+91${phone.text}",
                                    timeout: const Duration(seconds: 60),
                                    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                                      debugPrint("complete == $phoneAuthCredential");
                                    },
                                    verificationFailed: (failed) {},
                                    codeSent: (code, token) {
                                      loginController.verificationCodeforLogin.value = code;
                                      hideLoadingDialog();
                                      debugPrint("code == $token");
                                      Get.to(() => PinputScreen(phone: phone.text));
                                    },
                                    codeAutoRetrievalTimeout: (timeout) {});
                              }
                            }
                            /*debugPrint("---data---${FirebaseAuth.instance.currentUser}");
                          final FirebaseFirestore yash = FirebaseFirestore.instance;
                          var data = yash.collection('Users');
                          // var data = await Firestore.instance.collection('Users');
                          debugPrint("mobile number == +91 ${phone.text}");
                          debugPrint("data = ${data}");
                          */
                            /*FirebaseAuth auth = FirebaseAuth.instance;
                          auth.verifyPhoneNumber(
                              phoneNumber: "+91 ${phone.text}",
                              timeout: const Duration(seconds: 60),
                              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                                debugPrint("complete == $phoneAuthCredential");
                              },
                              verificationFailed: (failed) {},
                              codeSent: (code, token) {
                                setState(() {
                                  verificationCode = code;
                                });
                                debugPrint("token == $token");
                              },
                              codeAutoRetrievalTimeout: (timeout) {});*/
                            /*
                          setState(() {});*/
                          },
                          child: customContainer(
                              child:
                                  "Send OTP") /*Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(010)),
                            child: const Text(
                              "Send OTP",
                              style: TextStyle(fontSize: 20),
                            ),
                          )*/
                          ,
                        ),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                /*CommonTexField(
                  controller: otp,
                  hintText: "Enter Otp",
                ),*/

                ///verify code
                /*Center(
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode.toString(), smsCode: otp.text);
                        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                        debugPrint("=======>${userCredential.user}");
                        if (userCredential.user != null) {
                          Get.to(() => const DashBoardScreen());
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
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(010)),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTextStyle.regular.copyWith(color: AppColors.blackColor, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const SignUpScreen(), transition: Transition.topLevel, duration: const Duration(seconds: 2));
                      },
                      child: Text(
                        ' Sign Up',
                        style: AppTextStyle.semiBold.copyWith(color: AppColors.primaryColor, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
