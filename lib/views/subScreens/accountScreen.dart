import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/launch_controller.dart';
import 'package:task_masters/views/authScreens/loginScreen.dart';
import 'package:task_masters/views/subScreens/accountsComponents/pointsHistory.dart';
import 'package:task_masters/views/subScreens/activityScreen.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/appDialogs.dart';

import 'accountsComponents/editMyAccount.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: titleAppBar(context: context),
        backgroundColor: AppColor.white,
        body: GetBuilder(
          init: AuthController(),
          builder: (_) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                ///PROFILE IMAGE
                authController.profile!.profileImage.isEmpty ?
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  width: ScreenSize.width(context) * 0.15,
                  height: ScreenSize.height(context) * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child:  const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColor.white,
                      )
                  ),
                ) :
                Container(
                  color: AppColor.white,
                  width: ScreenSize.height(context) * 0.15,
                  height: ScreenSize.height(context) * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child:  Image.network(
                        authController.profile!.profileImage,
                        fit: BoxFit.cover,
                      )
                  ),
                ),

                ///USER DETAILS
                Card(
                  elevation: 0.0,
                  child: ListTile(
                    title: Text(
                      authController.profile!.name!,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                       "Email : ${authController.profile!.email!}",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ),


                GestureDetector(
                  onTap: (){
                    Get.to(() => const PointsHistory());
                  },
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                    color: AppColor.primaryColor,
                      elevation: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "  POINTS : ${authController.profile!.points!}  ",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColor.white,

                          ),
                        ),
                      ),
                  ),
                ),




                Divider(
                  height: ScreenSize.height(context) * 0.025,
                  thickness: 2,
                  color: AppColor.black.withOpacity(0.4),
                ),

                AccountTile(
                  iconData: Icons.edit,
                  title: 'Edit My Account',
                  onTap: () {
                    Get.to(
                          () => const EditMyAccount(),
                    );
                  },
                ),





                AccountTile(
                  iconData: Icons.checklist,
                  title: 'Activity History',
                  onTap: () {
                    Get.to(
                          () =>  const ActivityScreen(backButton: true,),

                    );
                  },
                ),



                AccountTile(
                    iconData: Icons.report,
                    title: 'Report An Issue',
                    onTap: () {
                      launchController.launchEmailForReportAnIssue();
                    }),

                AccountTile(
                    iconData: Icons.help,
                    title: 'Help',
                    onTap: () {
                      launchController.launchEmailForHelp();
                    }),

                AccountTile(
                  iconData: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    yesNoDialog(
                      context: context,
                      text: 'Do you want to logout?',
                      onTap: () {
                        authController.logoutUser();
                      },
                    );
                  },
                ),
                // AccountTile(
                //   iconData: Icons.delete,
                //   title: 'Delete Account',
                //   onTap: () {
                //     yesNoDialogOld(
                //       context,
                //       text: 'Do you want to delete the account?',
                //       onTap: userController.deleteUserAccount,
                //     );
                //   },
                // ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({
    Key? key,
    required this.iconData,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenSize.height(context) * 0.05,
        margin: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.0),
              blurRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColor.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.blackMild,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColor.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}


