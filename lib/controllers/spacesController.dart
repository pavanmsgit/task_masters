// ignore_for_file:prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors,file_names
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:task_masters/services/spacesService.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/toastMessage.dart';

import '../models/spaces.dart';

final SpacesController spacesController = Get.find<SpacesController>();

class SpacesController extends GetxController {
  RxBool phoneAvailable = true.obs,
      loginObscure = false.obs,
      registerPasswordObscure = false.obs,
      registerConfirmObscure = false.obs;

  TextEditingController spaceNameController = TextEditingController(),
      spaceDescriptionController = TextEditingController(),
      spaceCapacityController = TextEditingController(),
      chatsController = TextEditingController();

  FocusNode spaceNameNode = FocusNode(),
      spaceDescriptionNode = FocusNode(),
      spaceCapacityNode = FocusNode();

  final GlobalKey<FormState> createSpaceKey = GlobalKey<FormState>(),
      updateSpaceKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  SpacesService spacesService = SpacesService();
  UserData userData = UserData();

  var rand = Random();

  File? spacesImageFile;
  String? spacesImageFileName;

  RxInt currentCapacity = 0.obs;

  List<UserModel> spaceUsersList = [];
  RxBool addUsersButtonStatus = false.obs;


  Future checkSpaceCurrentCapacity({required var spaceCapacity,required String spaceDocId}) async {
    var res = await FirebaseFirestore
        .instance
        .collection('spaces')
        .doc(spaceDocId)
        .collection("members")
        .get();

    currentCapacity.value = spaceCapacity - res.docs.length;
    update();
  }


  ///UPDATES THE BOTTOM BAR STATUS
  updateStatusForBottomButton() {
    if (spaceUsersList.isEmpty) {
      addUsersButtonStatus.value = false;
    } else {
      addUsersButtonStatus.value = true;
    }
    update();
  }

  ///SENDS A MESSAGE TO THE GROUP
  sendMessage({required String spaceDocId}) {
    String referenceId =
        rand.nextInt(10000).toString() + rand.nextInt(10000).toString();

    if (chatsController.text.isEmpty) {
      showToast("Please enter the message", ToastGravity.CENTER);
      return;
    }

    try {
      var res = spacesService.addMessageToTheSpace(
          spaceDocId: spaceDocId,
          referenceId: referenceId,
          user: authController.profile!,
          message: chatsController.text);

      chatsController.clear();

    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
  }

  ///SELECTS A IMAGE FILE FROM THE FILES
  selectImage() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      spacesImageFile = File(img.path);
      update();
    }
  }

  ///CREATES A NEW SPACE
  createSpace() async {
    String spacesId =
        rand.nextInt(10000).toString() + rand.nextInt(10000).toString();

    if (spaceNameController.text.isEmpty) {
      showToast("Please enter Space Name", ToastGravity.CENTER);
      return;
    } else if (spaceDescriptionController.text.isEmpty) {
      showToast("Please enter Space Description", ToastGravity.CENTER);
      return;
    } else if (spaceCapacityController.text.isEmpty) {
      showToast("Please enter Space Capacity", ToastGravity.CENTER);
      return;
    } else if (spacesImageFile == null) {
      showToast("Please select the Space Image", ToastGravity.CENTER);
      return;
    }

    try {
      showSpinner();

      bool res = await spacesService.createSpace(
          user: authController.profile!,
          spaceId: spacesId,
          spaceName: spaceNameController.text,
          spaceDescription: spaceDescriptionController.text,
          spaceCapacity: int.parse(spaceCapacityController.text),
          spaceAdminName: authController.profile!.name,
          spaceAdminEmail: authController.profile!.email,
          spaceAdminImage: authController.profile!.profileImage,
          spaceUsers: [authController.profile!.email],
          spacesImageFile: spacesImageFile);

      if (res) {
        showToast('Space Created', ToastGravity.BOTTOM);
        clearAllSpacesFields();
        Get.back();
      }
    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
    hideSpinner();
  }

  ///CLEARS ALL THE INPUTS FROM THE USER AFTER CREATING A SPACE
  clearAllSpacesFields() {
    spaceNameController.clear();
    spaceDescriptionController.clear();
    spaceCapacityController.clear();
    spacesImageFile = null;
    update();
  }

  ///ADD TO SPACE USER LIST
  addToSpaceUserList({required UserModel user}) {
    spaceUsersList.add(user);
    update();
  }

  ///REMOVE FROM SPACE USER LIST
  removeFromSpaceUserList({required UserModel user}) {
    spaceUsersList.remove(user);
    update();
  }

  ///UPDATE SPACE USERS DOCUMENT
  updateSpaceUsers({required String spaceDocId,required Spaces space}) async {
    if (spaceUsersList.isEmpty) {
      showToast("Please Select At-least One User", ToastGravity.CENTER);
      return;
    }

    bool res = false;
    List<dynamic> spaceUsersUpdatedList = space.spaceUsers;

    try {
      showSpinner();

      for (UserModel user in spaceUsersList) {
        res = await spacesService.addSpaceUser(
            spaceDocId: spaceDocId, user: user);

        spaceUsersUpdatedList.add(user.email);
      }

      await spacesService.addSpaceUserList(spaceDocId: spaceDocId, spaceUserList: spaceUsersUpdatedList);


      if (res) {
        showToast('Users Added', ToastGravity.BOTTOM);
        clearSpaceUserList();
      }
    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
    hideSpinner();
  }

  ///CLEARS THE ARRAY
  clearSpaceUserList() {
    spaceUsersList.clear();
    currentCapacity.value = 0;
    update();
    Get.back();
  }
}
