import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_masters/models/userModel.dart';

class SocialService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  ///ADD FRIEND
  Future<bool> addFriend({required UserModel user,required String currentUserEmail}) async {
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
