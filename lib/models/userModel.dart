///NEW FILE
///
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userProfileFromJson(str) => UserModel.fromJson((str));

String userProfileToJson(UserModel data) => json.encode(data.toJson());

List<UserModel> usersFromJson(str) =>
    List<UserModel>.from((str).map((x) => UserModel.fromJson(x.data())));

String usersToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  DocumentReference<Object?>? reference;

  UserModel({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.createdAt,
    required this.status,
    this.phone,
    this.token,
    this.addressLatLong,
    this.address,
    this.points,
  });

  late String name;
  late String email;
  late String profileImage;
  late Timestamp createdAt;
  late bool status;
  late String? phone;
  late String? token;
  late GeoPoint? addressLatLong;
  late String? address;
  late var points;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        profileImage: json["profileImage"],
        token: json["token"],
        createdAt: json["createdAt"],
        status: json["status"],
        addressLatLong: json["addressLatLong"],
        address: json["address"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "profileImage": profileImage,
        "token": token,
        "createdAt": createdAt,
        "status": status,
        "addressLatLong": addressLatLong,
        "address": address,
        "points": points,
      };

  UserModel.fromMap(json, {this.reference}) {
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    profileImage = json["profileImage"];
    token = json["token"];
    createdAt = json["createdAt"];
    status = json["status"];
    addressLatLong = json["addressLatLong"];
    address = json["address"];
    points = json["points"];
  }

  UserModel.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
