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
         title: 'Task Masters',
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Codesundar")),
      body: Container(
        child: _isLoggedIn
            ? Column(
          children: [
            Image.network(_userObj.photoUrl!),
            Text(_userObj.displayName!),
            Text(_userObj.email),
            TextButton(
                onPressed: () {
                  _googleSignIn.signOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                    });
                  }).catchError((e) {});
                },
                child: const Text("Logout"))
          ],
        )
            : Center(
          child: ElevatedButton(
            child: const Text("Login with Google"),
            onPressed: () {
              _googleSignIn.signIn().then((userData) {
                setState(() {
                  _isLoggedIn = true;
                  _userObj = userData!;
                });
              }).catchError((e) {
                print(e);
              });
            },
          ),
        ),
      ),
    );
  }
}