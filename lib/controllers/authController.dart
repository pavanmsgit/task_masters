// ignore_for_file:prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors,file_names
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_masters/const/appImages.dart';
import 'package:task_masters/models/userModel.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';
import 'package:task_masters/services/authService.dart';
import 'package:task_masters/views/homeMainScreen.dart';
import 'package:task_masters/views/authScreens/loginScreen.dart';
import 'package:task_masters/views/splash_screen.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/toastMessage.dart';

final AuthController authController = Get.find<AuthController>();

class AuthController extends GetxController {
  RxBool profileChanged = false.obs;

  String verificationId = '';

  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      pointsController = TextEditingController();

  FocusNode nameNode = FocusNode(),
      emailNode = FocusNode(),
      phoneNode = FocusNode(),
      pointsNode = FocusNode();

  final GlobalKey<FormState> registerKey = GlobalKey<FormState>(),
      loginKey = GlobalKey<FormState>(),
      updateProfileKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  AuthService authService = AuthService();
  UserData userData = UserData();

  UserModel? profile;
  String imageUrl = '';
  String points = '';

  File? imageFile;
  RxBool imageUpdated = false.obs;

  ///GETS USER PROFILE AND UPDATES IT
  getUserProfile() async {
    profile = await authService.getProfile();
    name.text = profile!.name;
    email.text = profile!.email;
    phone.text = profile!.phone ?? "";
    pointsController.text = profile!.points!.toString();
    points = profile!.points!.toString();
    imageUrl = profile?.profileImage ?? "";
    update();
  }

  ///SELECTS A IMAGE FILE FROM THE FILES
  selectImage() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      imageFile = File(img.path);
      imageUpdated.value = true;
      profileChanged.value = true;
      update();
    }
  }

  ///FOR UPDATE PROFILE BOTTOM BAR
  updateProfileChanged() {
    profileChanged.value = true;
    update();
  }

  updateProfileChangedToFalse() {
    profileChanged.value = false;
    update();
  }

  //CHECKING IF USER IS LOGGED IN OR NOT
  checkAuth() {
    Future.delayed(2.seconds, () async {
      String user = await userData.getUserEmail();

      if (user.isEmpty) {
        Get.off(() => const LoginScreen());
      } else {
        Get.off(() => const HomeScreenMain());
      }
    });
  }

  ///LOGIN USER - IF ALREADY REGISTERED
  loginUser() async {
    if (loginKey.currentState!.validate()) {
      showSpinner();
      try {
        UserCredential res = await authService.signInWithGoogle();

        if (!res.isBlank!) {
          ///CHECKS THE COUNT - RETURNS 1 IF THE USER EXISTS IN THE DB ELSE IF THE USER IS NEW THE RESULT WILL BE 0
          Future<int> checkStatus = authService.checkIfUserIsRegistered(email: res.user!.email!);

          ///RETRIEVING INT FROM FUTURE<INT>
          checkStatus.then((value) async {
            ///CHECKS THE COUNT - RETURNS 1 IF THE USER EXISTS IN THE DB ELSE IF THE USER IS NEW THE RESULT WILL BE 0
            if (value == 0) {
              ///REGISTERS USER TO THE DATABASE
              await authService.registerUser(
                  name: res.user!.displayName!,
                  email: res.user!.email!,
                  profileImage: res.user!.photoURL!,
                  address: '');
            } else {
              ///ADDS LATEST TOKEN TO DB
              await authService.registerTokenToDB(email: res.user!.email!);
            }


          });

          ///SET USER EMAIL TO SHARED PREFERENCES
          await userData.setUserEmail(email: res.user!.email);

          ///CLEARS ALL THE ROOT AND NAVIGATES TO THE HOME SCREEN
          Get.offAll(
            () => const HomeScreenMain(),
          );

        } else {
          //showToast('Failed to login', ToastGravity.BOTTOM);
        }
      } catch (err) {
        //showToast('Server Not Found', ToastGravity.BOTTOM);
      }
      hideSpinner();
    }
  }

  ///LOGOUT USER FROM THE DEVICE
  logoutUser() async {
    showSpinner();
    try {
      ///LOG OUT FROM GOOGLE
      await authService.signOutFromGoogle();

      ///CLEARS ALL THE STORAGE
      GetStorage().erase();

      ///NAVIGATES TO LOGIN SCREEN CLEARING THE PREVIOUS ROUTE
      Get.offAll(
        () => const LoginScreen(),
      );
    } catch (err) {
      //showToast('Server Not Found', ToastGravity.BOTTOM);
    }
    hideSpinner();
  }

  ///UPDATES USER NAME, NUMBER AND PHOTO
  updateUserInfo() async {
    showSpinner();
    try {
      bool res = await authService.updateProfile(
          name: name.text,
          phone: phone.text,
          email: email.text,
          profileImage: authController.profile!.profileImage,
          image: imageFile);

      if (res) {
        showToast('Profile Updated', ToastGravity.BOTTOM);
        authController.getUserProfile();
        clearUpdateUserFields();

        Get.back();
      }
    } catch (err) {
      showToast('Server Not Found', ToastGravity.BOTTOM);
    }
    hideSpinner();
  }



  clearUpdateUserFields(){
    imageFile = null;
    imageUpdated.value = false;
    profileChanged.value = false;
    update();
  }
}
