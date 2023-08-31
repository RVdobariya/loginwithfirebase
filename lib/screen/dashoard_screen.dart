import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignupwithfirebase/screen/signin_screen.dart';

import '../main.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), centerTitle: true),
      body: SafeArea(
          child: Center(
        child: InkWell(
          onTap: () {
            FirebaseAuth.instance.signOut();
            getStorage!.remove("isLogin");
            getStorage!.erase();
            Get.offAll(
              () => const SignInScreen(),
            );
          },
          child: const Text("Log out"),
        ),
      )),
    );
  }
}
