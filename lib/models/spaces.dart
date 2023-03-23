import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Spaces> spacesFromJson(str) =>
    List<Spaces>.from((str).map((x) => Spaces.fromJson(x.data())));

String spacesToJson(List<Spaces> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spaces {
  DocumentReference<Object?>? reference;

  Spaces({
    required this.spaceId,
    required this.spaceName,
    required this.spaceDescription,
    required this.spaceImage,
    required this.spaceAdminName,
    required this.spaceAdminEmail,
    required this.spaceAdminImage,
    required this.spaceUsers,
    required this.spaceCreatedAt,
    required this.spaceCapacity,
    required this.status,
  });

  late String spaceId;
  late String spaceName;
  late String spaceDescription;
  late String spaceImage;
  late String spaceAdminName;
  late String spaceAdminEmail;
  late String spaceAdminImage;
  late List<dynamic> spaceUsers;
  late Timestamp spaceCreatedAt;
  late var spaceCapacity;
  late bool status;

  factory Spaces.fromJson(Map<String, dynamic> json) => Spaces(
        spaceId: json["spaceId"],
        spaceName: json["spaceName"],
        spaceDescription: json["spaceDescription"],
        spaceImage: json["spaceImage"],
        spaceAdminName: json["spaceAdminName"],
        spaceAdminImage: json["spaceAdminImage"],
        spaceCapacity: json["spaceCapacity"],
        spaceAdminEmail: json["spaceAdminEmail"],
        spaceUsers: json["spaceUsers"],
        spaceCreatedAt: json["spaceCreatedAt"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "spaceId": spaceId,
        "spaceName": spaceName,
        "spaceDescription": spaceDescription,
        "spaceImage": spaceImage,
        "spaceAdminName": spaceAdminName,
        "spaceAdminImage": spaceAdminImage,
        "spaceCapacity": spaceCapacity,
        "spaceAdminEmail": spaceAdminEmail,
        "spaceUsers": spaceUsers,
        "spaceCreatedAt": spaceCreatedAt,
        "status": status,
      };

  Spaces.fromMap(json, {this.reference}) {
    spaceId = json["spaceId"];
    spaceName = json["spaceName"];
    spaceDescription = json["spaceDescription"];
    spaceImage = json["spaceImage"];
    spaceAdminName = json["spaceAdminName"];
    spaceAdminImage = json["spaceAdminImage"];
    spaceCapacity = json["spaceCapacity"];
    spaceAdminEmail = json["spaceAdminEmail"];
    spaceUsers = json["spaceUsers"];
    spaceCreatedAt = json["spaceCreatedAt"];
    status = json["status"];
  }

  Spaces.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
