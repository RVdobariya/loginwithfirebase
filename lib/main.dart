import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loginsignupwithfirebase/config/app_color.dart';
import 'package:loginsignupwithfirebase/screen/signin_screen.dart';

GetStorage? getStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  getStorage = GetStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "mukta_malar",
        backgroundColor: AppColors.backgroundColor,
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}
