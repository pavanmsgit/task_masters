import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/controllers/taskController.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/appButtons.dart';
import 'package:task_masters/widgets/spinner.dart';
import 'package:intl/intl.dart';
import 'package:task_masters/widgets/titleTextField.dart';

class CreateTasks extends StatefulWidget {
  const CreateTasks({Key? key,required this.spaceDocId}) : super(key: key);
  final String spaceDocId;

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Spinner(
        child: Scaffold(
          appBar: titleAppBarWithBackButton(title: "CREATE NEW TASK", subTitle: '', context: context),
          backgroundColor: AppColor.white,
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

                            ///TASK NAME TEXT FIELD
                            TitleTextField(
                              showTitle: true,
                              title: 'Task Name',
                              hint: 'Task Name',
                              controller: taskController.taskNameController,
                              node: taskController.taskNameNode,
                              onSubmit: (value) => taskController
                                  .taskDescriptionNode
                                  .requestFocus(),
                            ),

                            ///TASK DESCRIPTION TEXT FIELD
                            TitleTextField(
                              showTitle: true,
                              title: 'Task Description',
                              hint: 'Task Description',
                              len: 50,
                              controller:
                              taskController.taskDescriptionController,
                              node: taskController.taskDescriptionNode,
                              onSubmit: (value) => taskController
                                  .taskPointsNode
                                  .requestFocus(),
                            ),

                            ///TASK POINTS TEXT FIELD
                            TitleTextField(
                              showTitle: true,
                              title: 'Task Points',
                              hint: 'Task Points',
                              controller:
                              taskController.taskPointsController,
                              node: taskController.taskPointsNode,
                              onSubmit: (value) => taskController.taskPointsNode.unfocus(),
                            ),

                            const SizedBox(height: 20),


                           ///TASK SELECTED TIME
                           Obx(() =>  taskController.taskSelectedTimeString.value == "" ?
                           ElevatedButton(
                             style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor)
                             ),
                             onPressed: () async {
                               taskController.taskSelectedTime = await showOmniDateTimePicker(
                                 context: context,
                                 initialDate: DateTime.now(),
                                 firstDate: DateTime.now(),
                                 lastDate: DateTime.now().add(
                                   const Duration(days: 365),
                                 ),
                                 type: OmniDateTimePickerType.dateAndTime,
                                 is24HourMode: false,
                                 isShowSeconds: false,
                                 minutesInterval: 15,
                                 secondsInterval: 1,
                                 borderRadius: const BorderRadius.all(Radius.circular(16)),
                                 constraints: const BoxConstraints(
                                   maxWidth: 350,
                                   maxHeight: 650,
                                 ),
                                 transitionBuilder: (context, anim1, anim2, child) {
                                   return FadeTransition(
                                       opacity: anim1.drive(
                                         Tween(
                                           begin: 0,
                                           end: 1,
                                         ),
                                       ),
                                       child: child
                                   );
                                 },
                                 transitionDuration: const Duration(milliseconds: 200),
                                 barrierDismissible: true,
                               );
                               taskController.updateSelectedTimeString();
                             },
                             child: const Text("Select Task Time"),
                           ) :
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 0),
                                 child: AutoSizeText(
                                   "SELECTED TIME : ${taskController.taskSelectedTimeString.toString()}",
                                   maxLines: 1,
                                   style: const TextStyle(
                                     fontSize: 15,
                                     fontWeight: FontWeight.w400,
                                   ),
                                 ),
                               ),

                               ElevatedButton(
                                 style: ButtonStyle(
                                     backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor)
                                 ),
                                 onPressed: () async {
                                   taskController.taskSelectedTime = await showOmniDateTimePicker(
                                     context: context,
                                     initialDate: DateTime.now(),
                                     firstDate: DateTime.now(),
                                     lastDate: DateTime.now().add(
                                       const Duration(days: 365),
                                     ),
                                     type: OmniDateTimePickerType.dateAndTime,
                                     is24HourMode: false,
                                     isShowSeconds: false,
                                     minutesInterval: 15,
                                     secondsInterval: 1,
                                     borderRadius: const BorderRadius.all(Radius.circular(16)),
                                     constraints: const BoxConstraints(
                                       maxWidth: 350,
                                       maxHeight: 650,
                                     ),
                                     transitionBuilder: (context, anim1, anim2, child) {
                                       return FadeTransition(
                                           opacity: anim1.drive(
                                             Tween(
                                               begin: 0,
                                               end: 1,
                                             ),
                                           ),
                                           child: child
                                       );
                                     },
                                     transitionDuration: const Duration(milliseconds: 200),
                                     barrierDismissible: true,
                                   );
                                   taskController.updateSelectedTimeString();
                                 },
                                 child: const Text("Update Task Time"),
                               )
                             ],
                           ),),

                          ],
                        ),
                      ),

                      ///CREATE TASK BUTTON
                      TaskMastersButton(
                        buttonText: "Create",
                        onTap: () => taskController.createTask(spaceDocId: widget.spaceDocId),
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
