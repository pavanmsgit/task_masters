import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/homeController.dart';
import 'package:task_masters/preferences/userDataPrefs.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/appBottomNavBar.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/willPopBottomSheet.dart';


class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({Key? key}) : super(key: key);

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  final HomeController hc = Get.put(HomeController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authController.getUserProfile();
    });
    super.initState();
  }

  var phone;

  checkPrefs()async{
    phone = await UserData().getUserEmail();
    debugPrint("THIS IS USER PHONE NUMBER $phone");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Spinner(
        child: Scaffold(
          backgroundColor: AppColor.tertiaryColor,

          body: Obx(
                () => hc.screens.elementAt(hc.selectedTab.value),
          ),

          bottomNavigationBar: const AppBottomNav(),

        ),
      ),
    );
  }
}
