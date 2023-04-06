import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/homeController.dart';
import 'package:task_masters/const/appColors.dart';

titleAppBar(
    {required BuildContext context, Widget? tabBars, List<Widget>? actions}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(100.0),
    child: Container(
      width: ScreenSize.width(context),
      decoration: const BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )),
      child: AppBar(
        actions: actions ?? [],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: Obx(
          () => AutoSizeText(homeController.appBarTitles
              .elementAt(homeController.selectedTab.value),style: const TextStyle(color: AppColor.tertiaryColor),),
        ),
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: tabBars ??
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                  child: Obx(() => AutoSizeText(
                        homeController.appBarSubTitles
                            .elementAt(homeController.selectedTab.value),
                        style: const TextStyle(
                            color: AppColor.tertiaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ),
        ),
      ),
    ),
  );
}

titleAppBarWithBackButton(
    {required String? title,
    required String? subTitle,
    Function()? onPress,
    required BuildContext context,
    Widget? tabBars,
    List<Widget>? actions}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(100.0),
    child: Container(
      width: ScreenSize.width(context),
      decoration: const BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )),
      child: AppBar(
        actions: actions ?? [],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.tertiaryColor,
            size: 30,
          ),
          onPressed: onPress ??
              () {
                Get.back();
              },
        ),
        centerTitle: true,
        title: AutoSizeText(
          title ?? '',
          style: const TextStyle(
              color: AppColor.tertiaryColor, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: tabBars ??
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeText(
                  subTitle ?? '',
                  style: const TextStyle(
                      color: AppColor.tertiaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ),
        ),
      ),
    ),
  );
}


