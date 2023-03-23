import 'package:flutter/material.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/appImages.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //CHECKS AUTHENTICATION STATUS
    authController.checkAuth();

    authController.getUserProfile();

    // locationController.getLocationPermission();
    // locationController.getLatestAddress().whenComplete(() => true);
    // assetController.updateAssetInfoForFilter(null).whenComplete(() => true);
    return Scaffold(
      body: Container(
        color: AppColor.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(),
            Expanded(
              child: Center(
                child: Image(
                  height: ScreenSize.height(context) * 0.18,
                  image: const AssetImage(
                    AppImages.appLogoTransparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
