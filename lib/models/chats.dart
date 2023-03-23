import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Chats> chatsFromJson(str) =>
    List<Chats>.from((str).map((x) => Chats.fromJson(x.data())));

String chatsToJson(List<Chats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chats {
  DocumentReference<Object?>? reference;

  Chats(
      {required this.referenceId,
        this.name,
        required this.email,
        this.phone,
        this.profileImage,
        required this.message,
        required this.referenceTimestamp});

  late String referenceId;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  late var message;
  late Timestamp referenceTimestamp;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
    referenceId: json["referenceId"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    referenceTimestamp: json["referenceTimestamp"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "referenceId": referenceId,
    "name": name,
    "email": email,
    "phone": phone,
    "profileImage": profileImage,
    "referenceTimestamp": referenceTimestamp,
    "message": message
  };

  Chats.fromMap(json, {this.reference}) {
    referenceId = json["referenceId"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    profileImage = json["profileImage"];
    referenceTimestamp = json["referenceTimestamp"];
    message = json["message"];
  }

  Chats.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
