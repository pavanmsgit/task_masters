import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/controllers/homeController.dart';



class AppBottomNav extends StatefulWidget {
  const AppBottomNav({Key? key}) : super(key: key);

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  final HomeController hc = Get.find<HomeController>();

  //ICON LIST FOR BOTTOM NAVIGATION BAR
  final iconList = <IconData>[
    Icons.supervised_user_circle,
    Icons.checklist,
    Icons.account_circle_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      iconSize: 30,
      backgroundColor:AppColor.primaryColor,
      activeColor: AppColor.tertiaryColor,
      notchMargin: 10,
      inactiveColor: AppColor.white,
      activeIndex: hc.selectedTab.value,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.smoothEdge,
      leftCornerRadius: 30,
      rightCornerRadius: 30,
      elevation: 10,
      onTap: (index) {
        setState(() {
          hc.selectedTab.value = index;
        });
      },
    );
  }
}

