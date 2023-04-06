// ignore_for_file:prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors,file_names
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/models/tasks.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';
import 'package:task_masters/services/authService.dart';
import 'package:task_masters/services/spacesService.dart';
import 'package:task_masters/services/taskService.dart';
import 'package:task_masters/views/homeMainScreen.dart';
import 'package:task_masters/views/authScreens/loginScreen.dart';
import 'package:task_masters/views/splash_screen.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/toastMessage.dart';

final TaskController taskController = Get.find<TaskController>();

class TaskController extends GetxController {
  TextEditingController taskNameController = TextEditingController(),
      taskDescriptionController = TextEditingController(),
      taskPointsController = TextEditingController();

  FocusNode taskNameNode = FocusNode(),
      taskDescriptionNode = FocusNode(),
      taskPointsNode = FocusNode();

  final GlobalKey<FormState> createTaskKey = GlobalKey<FormState>(),
      updateTaskKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  TaskService taskServices = TaskService();
  UserData userData = UserData();

  var rand = Random();
  DateTime? taskSelectedStartTime;
  DateTime? taskSelectedEndTime;
  RxString taskSelectedStartTimeString = "".obs;
  RxString taskSelectedEndTimeString = "".obs;

  ///UPDATE SELECTED START TIME STRING FROM DATE TIME
  updateSelectedStartTimeString() {
    taskSelectedStartTimeString?.value = DateFormat('dd-MM-yyyy – kk:mm a')
        .format(taskController.taskSelectedStartTime!);
    update();
  }

  ///UPDATE SELECTED END TIME STRING FROM DATE TIME
  updateSelectedEndTimeString() {
    taskSelectedEndTimeString?.value = DateFormat('dd-MM-yyyy – kk:mm a')
        .format(taskController.taskSelectedEndTime!);
    update();
  }

  ///CREATES A NEW TASK
  createTask({required String spaceDocId}) async {
    String taskId =
        rand.nextInt(10000).toString() + rand.nextInt(10000).toString();

    if (taskNameController.text.isEmpty) {
      showToast("Please enter Task Name", ToastGravity.CENTER);
      return;
    } else if (taskDescriptionController.text.isEmpty) {
      showToast("Please enter Task Description", ToastGravity.CENTER);
      return;
    } else if (taskPointsController.text.isEmpty) {
      showToast("Please enter Task Points", ToastGravity.CENTER);
      return;
    } else if (taskSelectedStartTimeString!.value.isEmpty) {
      showToast("Please Select Start time", ToastGravity.CENTER);
      return;
    }else if (taskSelectedEndTimeString!.value.isEmpty) {
      showToast("Please Select End time", ToastGravity.CENTER);
      return;
    }

    try {
      showSpinner();

      bool res = await taskServices.createTask(
          docId: spaceDocId,
          taskId: taskId,
          taskName: taskNameController.text,
          taskDescription: taskDescriptionController.text,
          taskTotalPoints: double.parse(taskPointsController.text),
          taskByName: authController.profile!.name,
          taskByEmail: authController.profile!.email,
          taskByImage: authController.profile!.profileImage,
          taskSelectedStartTime: taskSelectedStartTime!,
          taskSelectedEndTime: taskSelectedEndTime!,
      );

      if (res) {
        showToast('Task Created', ToastGravity.BOTTOM);
        clearAllTasksFields();
        Get.back();
      }
    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
    hideSpinner();
  }

  ///CLEARS ALL THE INPUTS FROM THE USER AFTER CREATING A SPACE
  clearAllTasksFields() {
    taskNameController.clear();
    taskDescriptionController.clear();
    taskPointsController.clear();
    taskSelectedStartTime = null;
    taskSelectedStartTimeString!.value = "";
    taskSelectedEndTimeString!.value = "";
    update();
  }

  ///UPDATE TASK STATUS
  updateTaskDetails(
      {required Tasks task,
      String? spaceDocId,
      required String taskDocId,
      required int status}) async {
    try {
      showSpinner();

      bool res = await taskServices.updateTaskStatus(
          task: task,
          spaceDocId: spaceDocId,
          taskDocId: taskDocId,
          acceptedByName: authController.profile!.name,
          acceptedByEmail: authController.profile!.email,
          acceptedByImage: authController.profile!.profileImage,
          status: status);

      if (res) {
        showToast('Task Updated', ToastGravity.BOTTOM);
        clearAllTasksFields();
        //Get.back();
      }
    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
    hideSpinner();
  }

  ///UPDATE USERS POINTS
  updatePointsDetails({required Spaces spaces, required Tasks task}) async {


    try {
      showSpinner();
      bool res = false;

      var points = task.taskTotalPoints/(spaces.spaceUsers.length-1);

      String referenceIdAlt = rand.nextInt(10000).toString() + rand.nextInt(10000).toString();

      ///REMOVES POINTS FOR ALL THE SPACE MEMBERS EXCEPT THE USER WHO COMPLETED THE TASK
      for (String userDocId in spaces.spaceUsers) {
        String referenceId = rand.nextInt(10000).toString() + rand.nextInt(10000).toString();

        //showToast("${task.acceptedByEmail}", ToastGravity.CENTER);

        ///CHECKING FOR THE CONDITION
        userDocId != task.acceptedByEmail  ?
         await taskServices.updateUserPointsInDB(
            userDocId: userDocId,
            points: points,
            referenceId: referenceId) : null;
      }


      ///UPDATES POINTS FOR THE USER WHO COMPLETED THE TASK
      res = await taskServices.updateTaskCompletedUserPointsInDB(
          userDocId: task.acceptedByEmail!,
          points: task.taskTotalPoints,
          referenceId: referenceIdAlt,
          name: task.acceptedByName!,
          email: task.acceptedByEmail!,
          profileImage: task.acceptedByImage!);

      if (res) {
        showToast('Points Updated', ToastGravity.BOTTOM);
        //Get.back();
      }
    } catch (err) {
      showToast(err.toString(), ToastGravity.BOTTOM);
    }
    hideSpinner();
  }
}
