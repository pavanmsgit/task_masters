import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/models/userModel.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';


class AuthService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  ///RETURNS CURRENT USER PROFILE
  Future getProfile() async {
    var email = await UserData().getUserEmail();
    var res = await firebaseFirestore.collection('users').doc(email).get();

    return userProfileFromJson(res.data());
  }


  ///UPDATE USER PROFILE
  Future<bool> updateProfile(
      {required String name,
        required String phone,
        required String email,
        required String profileImage,
        File? image}) async {
    String imageUrl = profileImage;

    if (image != null) {

      var imageTask = await firebaseStorage
          .ref('/user_images/$email')
          .putFile(image);

      imageUrl = await imageTask.ref.getDownloadURL();
    }

    await firebaseFirestore.collection('users').doc(email).update({
      "name": name,
      "phone": phone,
      "profileImage": imageUrl});
    return true;
  }


  ///CHECK EMAIL ADDRESS - IF IT EXISTS IN THE DATABASE OR NOT
  Future<int> checkIfUserIsRegistered({
    required String email
  }) async {
    var res = await firebaseFirestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get();

    return res.docs.length;
  }


  ///SIGN IN WITH GOOGLE METHOD
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  ///SIGNS OUT USER FROM THE DEVICE
  Future signOutFromGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }


  ///GOOGLE SING IN - REGISTER USER
  Future<bool> registerUser({
    required String name,
    required String email,
    String? phone,
    required String address,
    String? profileImage
  }) async {

    String? token = await firebaseMessaging.getToken();

    await firebaseFirestore.collection('users').doc(email).set({
      'name': name,
      'email': email,
      'phone': phone ?? "",
      'profileImage': profileImage ?? "",
      'createdAt': DateTime.now(),
      "status": true,
      "addressLatLong": const GeoPoint(0.00,0.00),
      "address": address ?? "",
      "token": token ?? "",
      "points": 100
    });

    ///ADDING TO SUB COLLECTION TO TRACK DATA
    await firebaseFirestore
        .collection("users")
        .doc(email)
        .collection("tokens")
        .add({
      "token": token,
      "timestamp": DateTime.now()
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




}
