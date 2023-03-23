// ignore_for_file:prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors,file_names
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/models/userModel.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';
import 'package:task_masters/services/socialService.dart';
import 'package:task_masters/services/spacesService.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/toastMessage.dart';

final SocialController socialController = Get.find<SocialController>();

class SocialController extends GetxController {


  SocialService socialService = SocialService();
  UserData userData = UserData();

  var rand = Random();

  ///ADDS A USER TO THE FRIENDS LIST
  addFriend({required UserModel user}) async {
    try {
      bool res = await socialService.addFriend(
          user: user,
         currentUserEmail: authController.profile!.email);


      if(res){
        showToast("Added Friend", ToastGravity.BOTTOM);
        //Get.back();
      }

    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
  }
}
