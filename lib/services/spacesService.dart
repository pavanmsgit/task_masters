import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_masters/models/userModel.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';

class SpacesService {
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

  ///CREATE NEW SPACE
  Future<bool> createSpace(
      {required String spaceId,
      required String spaceName,
      required String spaceDescription,
      required int spaceCapacity,
      File? spacesImageFile,
      required String spaceAdminName,
      required String spaceAdminEmail,
      required String spaceAdminImage,
      required List<String> spaceUsers,
      required UserModel user}) async {
    String? spaceImageUrl;

    if (spacesImageFile != null) {
      var imageTask = await firebaseStorage
          .ref('/spaces_images/${spacesImageFile.path.split('/').last}')
          .putFile(spacesImageFile);

      spaceImageUrl = await imageTask.ref.getDownloadURL();
    }

    await firebaseFirestore.collection('spaces').add({
      "spaceId": spaceId,
      "spaceName": spaceName,
      "spaceDescription": spaceDescription,
      "spaceImage": spaceImageUrl,
      "spaceAdminName": spaceAdminName,
      "spaceCapacity": spaceCapacity,
      "spaceAdminEmail": spaceAdminEmail,
      "spaceAdminImage": spaceAdminImage,
      "spaceUsers": spaceUsers,
      "spaceCreatedAt": DateTime.now(),
      "status": true
    }).then((documentAdded) async {
      ///ADDING ADMIN TO THE MEMBERS COLLECTION
      await firebaseFirestore
          .collection('spaces')
          .doc(documentAdded.id)
          .collection("members")
          .doc(user.email)
          .set({
        'name': user.name,
        'email': user.email,
        'phone': user.phone ?? "",
        'profileImage': user.profileImage ?? "",
        'createdAt': user.createdAt,
        "status": user.status,
        "addressLatLong": const GeoPoint(0.00, 0.00),
        "address": user.address ?? "",
        "token": user.token ?? ""
      });
    });

    return true;
  }

  ///ADD SPACE MEMBERS TO THE SPACE
  Future<bool> addSpaceUser(
      {required String spaceDocId, required UserModel user}) async {
    await firebaseFirestore
        .collection('spaces')
        .doc(spaceDocId)
        .collection("members")
        .doc(user.email)
        .set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone ?? "",
      'profileImage': user.profileImage ?? "",
      'createdAt': user.createdAt,
      "status": user.status,
      "addressLatLong": const GeoPoint(0.00, 0.00),
      "address": user.address ?? "",
      "token": user.token ?? ""
    });

    return true;
  }



  ///ADD SPACE MEMBERS TO THE LIST
  Future<bool> addSpaceUserList(
      {required String spaceDocId, required List<dynamic> spaceUserList}) async {
    await firebaseFirestore
        .collection('spaces')
        .doc(spaceDocId)
        .update({
      'spaceUsers': spaceUserList,
    });

    return true;
  }

  ///REGISTERS TOKEN TO DATABASE
  registerTokenToDB({required String? email}) async {
    String? token = await firebaseMessaging.getToken();

    ///UPDATING LATEST TOKEN
    await firebaseFirestore
        .collection("users")
        .doc(email)
        .update({"token": token});

    ///ADDING TO SUB COLLECTION TO TRACK DATA
    await firebaseFirestore
        .collection("users")
        .doc(email)
        .collection("tokens")
        .add({
      "token": token,
      "timestamp": DateTime.now(),
    });
  }

  ///ADDS MESSAGE TO THE DATABASE
  addMessageToTheSpace(
      {required String spaceDocId,
      required String referenceId,
      required UserModel user,
      String? message}) async {
    await firebaseFirestore
        .collection("spaces")
        .doc(spaceDocId)
        .collection("messages")
        .add({
      "referenceId": referenceId,
      "name": user.name,
      "email": user.email,
      "phone": user.phone,
      "profileImage": user.profileImage,
      "referenceTimestamp": DateTime.now(),
      "message": message
    });
  }


  ///ADD FRIENDS
  addFriend({required UserModel user,required String currentUserEmail}) async {
    await firebaseFirestore
        .collection('users')
        .doc(currentUserEmail)
        .collection("friends")
        .doc(user.email)
        .set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone ?? "",
      'profileImage': user.profileImage ?? "",
      'createdAt': user.createdAt,
      "status": user.status,
      "addressLatLong": const GeoPoint(0.00, 0.00),
      "address": user.address ?? "",
      "token": user.token ?? ""
    });

    return true;
  }



  ///REMOVE FRIEND
  removeFriend({required UserModel user,required String currentUserEmail}) async {
    await firebaseFirestore
        .collection('users')
        .doc(currentUserEmail)
        .collection("friends")
        .doc(user.email)
        .delete();

    return true;
  }




}
