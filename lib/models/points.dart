import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Points> pointsFromJson(str) =>
    List<Points>.from((str).map((x) => Points.fromJson(x.data())));

String pointsToJson(List<Points> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Points {
  DocumentReference<Object?>? reference;

  Points(
      {required this.referenceId, this.name,
      required this.email,
       this.phone,
       this.profileImage,
      required this.points,
      required this.referenceTimestamp});

  late String referenceId;
   String? name;
  late String email;
   String? phone;
   String? profileImage;
  late var points;
  late Timestamp referenceTimestamp;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        referenceId: json["referenceId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        profileImage: json["profileImage"],
        referenceTimestamp: json["referenceTimestamp"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "referenceId": referenceId,
        "name": name,
        "email": email,
        "phone": phone,
        "profileImage": profileImage,
        "referenceTimestamp": referenceTimestamp,
        "points": points
      };

  Points.fromMap(json, {this.reference}) {
    referenceId = json["referenceId"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    profileImage = json["profileImage"];
    referenceTimestamp = json["referenceTimestamp"];
    points = json["points"];
  }

  Points.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
