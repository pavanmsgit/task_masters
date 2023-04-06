import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/launch_controller.dart';
import 'package:task_masters/controllers/notificationController.dart';
import 'package:task_masters/controllers/socialController.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/controllers/taskController.dart';
import 'package:task_masters/views/splash_screen.dart';
import 'package:task_masters/widgets/willPopBottomSheet.dart';
import 'controllers/homeController.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(SpacesController());
  Get.put(SocialController());
  Get.put(TaskController());
  Get.put(LaunchController());
  Get.put(NotificationController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});



   @override
   Widget build(BuildContext context) {
     // final pushNotificationService = NotificationService(firebaseMessaging);
     // pushNotificationService.initialise();

     return WillPopScope(
       onWillPop: () => onWillPop(context),

       child: GetMaterialApp(
         debugShowCheckedModeBanner: false,
         title: 'TaskMaster',
         color: AppColor.primaryColor,
         theme: ThemeData(
           accentColor: AppColor.primaryColor,
           primaryColor: AppColor.primaryColor,
           appBarTheme:const AppBarTheme(
             backgroundColor: Colors.black,
           ),
         ),
         home: const SplashScreen(),
       ),
     );
   }
}
