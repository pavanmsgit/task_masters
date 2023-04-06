import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/appButtons.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:task_masters/widgets/titleTextField.dart';

class CreateSpace extends StatefulWidget {
  const CreateSpace({Key? key}) : super(key: key);

  @override
  State<CreateSpace> createState() => _CreateSpaceState();
}

class _CreateSpaceState extends State<CreateSpace> {




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Spinner(
        child: Scaffold(
          appBar: titleAppBarWithBackButton(title: "CREATE NEW SPACE", subTitle: '', context: context),
          backgroundColor: AppColor.tertiaryColor,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GetBuilder(
              init: SpacesController(),
              builder: (_) => Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Form(
                  key: spacesController.createSpaceKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TitleTextField(
                              showTitle: true,
                              title: 'Space Name',
                              hint: 'Space Name',
                              controller: spacesController.spaceNameController,
                              node: spacesController.spaceNameNode,
                              onSubmit: (value) => spacesController
                                  .spaceDescriptionNode
                                  .requestFocus(),
                            ),
                            TitleTextField(
                              showTitle: true,
                              title: 'Space Description',
                              hint: 'Space Description',
                              len: 50,
                              controller:
                                  spacesController.spaceDescriptionController,
                              node: spacesController.spaceDescriptionNode,
                              onSubmit: (value) => spacesController
                                  .spaceCapacityNode
                                  .requestFocus(),
                            ),
                            TitleTextField(
                              showTitle: true,
                              title: 'Space Capacity',
                              hint: 'Space Capacity',
                              controller:
                                  spacesController.spaceCapacityController,
                              node: spacesController.spaceCapacityNode,
                              onSubmit: (value) => spacesController.spaceCapacityNode.unfocus(),
                            ),


                            SelectImageButton(
                              title: 'Space Image',
                              image: spacesController.spacesImageFile,
                              onTap: spacesController.selectImage,
                            ),


                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      TaskMastersButton(
                        buttonText: "Create",
                        onTap: () => spacesController.createSpace(),
                      ),
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
