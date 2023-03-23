import 'package:get/get.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:url_launcher/url_launcher.dart';


final LaunchController launchController = Get.find<LaunchController>();

class LaunchController extends GetxController {


  ///LAUNCH PHONE APP TO MAKE PHONE CALL
  Future<void> makePhoneCall({required String phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }




  ///LAUNCH EMAIL FOR REPORT AN ISSUE
  launchEmailForReportAnIssue() async{
    String email = "taskmastersdevelopers@gmail.com";
    String subject = "Report An Issue : User ID : ${authController.profile!.email}";
    String body = "Please type your issues below this line:\n";
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
      //email app opened
    }else{
      //email app is not opened
    }
  }


  ///LAUNCH EMAIL FOR REPORT AN ISSUE
  launchEmailForHelp() async{
    String email = "taskmastersdevelopers@gmail.com";
    String subject = "Help / Enquiry : User ID : ${authController.profile!.email}";
    String body = "Please type your enquiry below this line:\n";
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
      //email app opened
    }else{
      //email app is not opened
    }
  }




}
