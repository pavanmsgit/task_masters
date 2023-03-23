import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Tasks> tasksFromJson(str) =>
    List<Tasks>.from((str).map((x) => Tasks.fromJson(x.data())));

String tasksToJson(List<Tasks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tasks {
  DocumentReference<Object?>? reference;

  Tasks({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskByName,
    required this.taskByEmail,
    required this.taskByImage,
    this.acceptedByName,
    this.acceptedByEmail,
    this.acceptedByImage,
    required this.status,
    required this.taskTotalPoints,
    required this.taskCreatedTimestamp,
    this.taskCompletedTimestamp,
    required this.taskSelectedTime,
    this.spaceTask,
  });

  late String taskId;
  late String taskName;
  late String taskDescription;
  late String taskByName;
  late String taskByEmail;
  late String taskByImage;
  late String? acceptedByName;
  late String? acceptedByEmail;
  late String? acceptedByImage;
  late int status;
  late var taskTotalPoints;
  late Timestamp taskSelectedTime;
  late Timestamp taskCreatedTimestamp;
  late Timestamp? taskCompletedTimestamp;
  late bool? spaceTask;

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        taskId: json["taskId"],
        taskName: json["taskName"],
        taskDescription: json["taskDescription"],
        taskByName: json["taskByName"],
        taskByEmail: json["taskByEmail"],
        taskByImage: json["taskByImage"],
        acceptedByName: json["acceptedByName"],
        acceptedByEmail: json["acceptedByEmail"],
        acceptedByImage: json["acceptedByImage"],
        status: json["status"],
        taskTotalPoints: json["taskTotalPoints"],
        taskSelectedTime: json["taskTime"],
        taskCreatedTimestamp: json["taskCreatedTimestamp"],
        taskCompletedTimestamp: json["taskCompletedTimestamp"],
    spaceTask: json["spaceTask"],
      );

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "taskName": taskName,
        "taskDescription": taskDescription,
        "taskByName": taskByName,
        "taskByEmail": taskByEmail,
        "acceptedByImage": acceptedByImage,
        "taskByImage": taskByImage,
        "acceptedByName": acceptedByName,
        "acceptedByEmail": acceptedByEmail,
        "status": status,
        "taskTotalPoints": taskTotalPoints,
        "taskTime": taskSelectedTime,
        "taskCreatedTimestamp": taskCreatedTimestamp,
        "taskCompletedTimestamp": taskCompletedTimestamp,
        "spaceTask": spaceTask,
      };

  Tasks.fromMap(json, {this.reference}) {
    taskId = json["taskId"];
    taskName = json["taskName"];
    taskDescription = json["taskDescription"];
    taskByName = json["taskByName"];
    taskByEmail = json["taskByEmail"];
    acceptedByImage = json["acceptedByImage"];
    taskByImage = json["taskByImage"];
    acceptedByName = json["acceptedByName"];
    acceptedByEmail = json["acceptedByEmail"];
    status = json["status"];
    taskTotalPoints = json["taskTotalPoints"];
    taskSelectedTime = json["taskSelectedTime"];
    taskCreatedTimestamp = json["taskCreatedTimestamp"];
    taskCompletedTimestamp = json["taskCompletedTimestamp"];
    spaceTask = json["spaceTask"];
  }

  Tasks.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
