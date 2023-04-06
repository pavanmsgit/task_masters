import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_masters/services/authService.dart';
import 'package:task_masters/views/subScreens/accountScreen.dart';
import 'package:task_masters/views/subScreens/activityScreen.dart';
import 'package:task_masters/views/subScreens/socialScreen.dart';
import 'package:task_masters/views/subScreens/spacesScreen.dart';

final HomeController homeController = Get.find<HomeController>();

class HomeController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  RxInt selectedTab = 0.obs;

  AuthService userService = AuthService();

  List appBarTitles = [
    'Spaces',
    'Activity',
    'My Profile'
  ];

  List appBarSubTitles = [
    'Manage Spaces',
    'History',
    'Manage profile'
  ];

  List screens = [
    const SpacesScreen(),
    const ActivityScreen(backButton: false,),
    const AccountScreen()
  ];
}
