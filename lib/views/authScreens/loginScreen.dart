import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/appImages.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/widgets/spinner.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Spinner(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.tertiaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: authController.loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      ///APP LOGO
                      CircleAvatar(
                        backgroundColor: AppColor.tertiaryColor,
                        radius: ScreenSize.width(context) * 0.25,
                        child: Center(
                          child: Image.asset(
                            AppImages.appLogoTransparent,
                            height: ScreenSize.height(context) * 0.25,
                          ),
                        ),
                      ),

                      const SizedBox(height: 150),



                      ///GOOGLE SIGN IN / SIGN UP BUTTON
                      Center(
                        child: SignInButton(
                          Buttons.Google,
                          padding: const EdgeInsets.only(left: 25.0),
                          elevation: 3.0,
                          shape:  RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(20.0),
                            side: const BorderSide(
                              style: BorderStyle.solid,
                              color: AppColor.white,
                              width: 3.0
                            ),
                          ),
                          onPressed: () async{
                            await authController.loginUser();
                          },
                        ),
                      ),

                      SizedBox(height: ScreenSize.height(context) * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
