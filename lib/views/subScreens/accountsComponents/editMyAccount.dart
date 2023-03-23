import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/appButtons.dart';
import 'package:task_masters/widgets/titleTextField.dart';
import 'package:task_masters/widgets/toastMessage.dart';

import '../../../const/appColors.dart';
import '../../../widgets/spinner.dart';

//UPDATE PROFILE
class EditMyAccount extends StatefulWidget {
  const EditMyAccount({Key? key}) : super(key: key);

  @override
  State<EditMyAccount> createState() => _EditMyAccountState();
}

class _EditMyAccountState extends State<EditMyAccount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Spinner(
        child: GetBuilder(
          init: AuthController(),
          builder: (_) => Scaffold(
            appBar: titleAppBarWithBackButton(
                title: "My Profile",
                subTitle: "Edit Account Details",
                context: context),
            backgroundColor: AppColor.white,
            body: SingleChildScrollView(
              child: Form(
                key: authController.updateProfileKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),

                    Obx(
                      () => authController.imageUpdated.value
                          ? Center(
                              child: CircleAvatar(
                                backgroundColor: AppColor.primaryColor,
                                radius: ScreenSize.width(context) * 0.12,
                                backgroundImage:
                                    FileImage(authController.imageFile!),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0, left: 60.0),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: authController.selectImage,
                                      child: const Icon(
                                        Icons.add_photo_alternate,
                                        color: AppColor.primaryColor,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircleAvatar(
                                backgroundColor: AppColor.primaryColor,
                                radius: ScreenSize.width(context) * 0.12,
                                backgroundImage: CachedNetworkImageProvider(
                                    authController.profile!.profileImage),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0, left: 60.0),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: authController.selectImage,
                                      child: const Icon(
                                        Icons.add_photo_alternate,
                                        color: AppColor.primaryColor,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    ///NAME
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackMild),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TitleTextField(
                            title: 'Name',
                            hint: 'Name',
                            textColor: AppColor.black,
                            hintTextColor: AppColor.grey,
                            cursorColor: AppColor.blackMild,
                            controller: authController.name,
                            keyboardType: TextInputType.text,
                            icon: const Icon(
                              Icons.person,
                              color: AppColor.primaryColor,
                            ),
                            node: authController.nameNode,
                            onChanged: (value) {
                              authController.updateProfileChanged();
                            },
                            onSubmit: (value) =>
                                authController.phoneNode.requestFocus(),
                          ),
                        ),
                      ],
                    ),

                    ///PHONE NUMBER
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackMild),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TitleTextField(
                            title: 'Phone',
                            hint: 'Phone',
                            textColor: AppColor.black,
                            hintTextColor: AppColor.grey,
                            cursorColor: AppColor.blackMild,
                            controller: authController.phone,
                            keyboardType: TextInputType.number,
                            icon: const Icon(
                              Icons.phone,
                              color: AppColor.primaryColor,
                            ),
                            node: authController.phoneNode,
                            onChanged: (value) {
                              authController.updateProfileChanged();
                            },
                            onSubmit: (value) =>
                                authController.phoneNode.unfocus(),
                          ),
                        ),
                      ],
                    ),

                    ///EMAIL
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackMild),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showToast("You can not change email address",
                                ToastGravity.CENTER);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TitleTextField(
                              title: 'Email',
                              hint: 'Email',
                              textColor: AppColor.black,
                              hintTextColor: AppColor.grey,
                              cursorColor: AppColor.blackMild,
                              enabled: false,
                              controller: authController.email,
                              keyboardType: TextInputType.emailAddress,
                              icon: const Icon(
                                Icons.email,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: ScreenSize.height(context) * 0.075,
                child: Obx(
                  () => TaskMastersButton(
                    buttonColor: authController.profileChanged.value == true
                        ? AppColor.primaryColor
                        : AppColor.grey,
                    onTap: () {
                      if (authController.profileChanged.value == true) {
                        authController.updateUserInfo();
                      } else {
                        showToast("No Fields Updated", ToastGravity.CENTER);
                      }
                    },
                    buttonText: 'UPDATE',
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
