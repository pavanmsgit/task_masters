
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

final NotificationController notificationController = Get.find<NotificationController>();

class NotificationController extends GetxController {

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String deviceToken = "";
  String deviceAPNSToken = "";

  ///GETS DEVICE TOKEN
  getDeviceToken() async{
    ///ANDROID
    deviceToken = (await firebaseMessaging.getToken())!;
    //if iOS
    //deviceAPNSToken = (await firebaseMessaging.getAPNSToken())!;
    update();
  }


}
