import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_masters/models/tasks.dart';
import 'package:task_masters/models/userModel.dart';
import 'package:task_masters/widgets/toastMessage.dart';

class TaskService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  ///CHECK IF SPACES NAME AVAILABLE
  Future<int> checkIfSpacesNameAvailable({required String spaceName}) async {
    var res = await firebaseFirestore
        .collection('users')
        .where("spaces", isEqualTo: spaceName)
        .get();

    return res.docs.length;
  }

  ///CREATE NEW TASK
  Future<bool> createTask({
    required String docId,
    required String taskId,
    required String taskName,
    required String taskDescription,
    required double taskTotalPoints,
    required String taskByName,
    required String taskByEmail,
    required String taskByImage,
    required DateTime taskSelectedTime,
  }) async {
    await firebaseFirestore
        .collection('spaces')
        .doc(docId)
        .collection("tasks")
        .add({
      "taskId": taskId,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "taskTotalPoints": taskTotalPoints,
      "taskSelectedTime": taskSelectedTime,
      "taskByName": taskByName,
      "taskByEmail": taskByEmail,
      "taskByImage": taskByImage,
      "taskCreatedTimestamp": DateTime.now(),
      "status": 0,
    });

    return true;
  }

  ///UPDATE TASK DETAILS
  Future<bool> updateTaskStatus(
      {String? spaceDocId,
      required String taskDocId,
      required Tasks task,
      required String acceptedByName,
      required String acceptedByEmail,
      required String acceptedByImage,
      required int status}) async {
    switch (status) {
      case 1:
        ///UPDATES TASK DETAILS WITH THE ACCEPTED USER'S INFO
        await firebaseFirestore
            .collection('spaces')
            .doc(spaceDocId)
            .collection("tasks")
            .doc(taskDocId)
            .update({
          "acceptedByName": acceptedByName,
          "acceptedByEmail": acceptedByEmail,
          "acceptedByImage": acceptedByImage,
          "status": 1
        });

        ///CREATING ANOTHER TASKS COLLECTION TO TRACK OVERALL ACCEPTED TASKS
        await firebaseFirestore.collection('tasksOverall').doc(taskDocId).set({
          "taskId": task!.taskId,
          "taskName": task!.taskName,
          "taskDescription": task!.taskDescription,
          "taskTotalPoints": task!.taskTotalPoints,
          "taskSelectedTime": task!.taskSelectedTime,
          "taskByName": task!.taskByName,
          "taskByEmail": task!.taskByEmail,
          "taskByImage": task!.taskByImage,
          "taskCreatedTimestamp": task!.taskCreatedTimestamp,
          "acceptedByName": acceptedByName,
          "acceptedByEmail": acceptedByEmail,
          "acceptedByImage": acceptedByImage,
          "status": 1,
          "spaceTask": spaceDocId!.isEmpty ? false : true
        });
        break;

      case 2:

        ///MARKS THE TASK AS COMPLETED
        await firebaseFirestore
            .collection('spaces')
            .doc(spaceDocId)
            .collection("tasks")
            .doc(taskDocId)
            .update({"taskCompletedTimestamp": DateTime.now(), "status": 2});

        ///CREATING ANOTHER TASKS COLLECTION TO TRACK OVERALL COMPLETED TASKS
        await firebaseFirestore
            .collection('tasksOverall')
            .doc(taskDocId)
            .update({"taskCompletedTimestamp": DateTime.now(), "status": 2});

        break;

      case 3:

        ///CANCELS THE TASK
        await firebaseFirestore
            .collection('spaces')
            .doc(spaceDocId)
            .collection("tasks")
            .doc(taskDocId)
            .update({"status": 3});
        break;

      ///BY DEFAULT THE TASK WILL BE CANCELLED - IF THERE ARE ANY ERRORS
      default:
        await firebaseFirestore
            .collection('spaces')
            .doc(spaceDocId)
            .collection("tasks")
            .doc(taskDocId)
            .update({"status": 3});
        break;
    }

    return true;
  }



  ///UPDATES USER POINTS IN THE DATABASE
  Future<bool> updateUserPointsInDB({
    required String userDocId,
    required var points,
    required var referenceId}) async {


    ///GETTING CURRENT POINTS
    var pointsExisting =  await firebaseFirestore
        .collection('users')
        .doc(userDocId)
        .get();


    ///UPDATING FINAL POINTS TO THE PROFILE
    var finalPoints = pointsExisting["points"] - points;

    await firebaseFirestore
        .collection('users')
        .doc(userDocId)
        .update({
      "points": finalPoints,
    });


    ///ADDING DATA TO POINTS HISTORY
    await firebaseFirestore
        .collection('points')
        .add({
      "referenceId": referenceId,
      "referenceTimestamp": DateTime.now(),
      "email": userDocId,
      "points": -points
    });

    return true;
  }



  ///UPDATES USER POINTS IN THE DATABASE
  Future<bool> updateTaskCompletedUserPointsInDB({
    required String userDocId,
    required var points,
    required var referenceId,
    required var name,
    required var email,
    required var profileImage,
  }) async {

    var pointsExisting =  await firebaseFirestore
        .collection('users')
        .doc(userDocId)
        .get();


    var finalPoints = pointsExisting["points"] + points;

    await firebaseFirestore
        .collection('users')
        .doc(userDocId)
        .update({
      "points": finalPoints,
    });

    await firebaseFirestore
        .collection('points')
        .add({
      "referenceId": referenceId,
      "referenceTimestamp": DateTime.now(),
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "points": points
    });

    return true;
  }


}
