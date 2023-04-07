import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/taskController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/models/tasks.dart';
import 'package:task_masters/views/subScreens/spacesComponents/chatsScreen.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/createTasks.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/manageSpaceMembers.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appDialogs.dart';
import 'package:task_masters/widgets/shimmer.dart';
import 'package:task_masters/widgets/toastMessage.dart';

class ViewTasks extends StatefulWidget {
  const ViewTasks({Key? key, required this.spaceDocId,required this.space}) : super(key: key);
  final String spaceDocId;
  final Spaces space;

  @override
  State<ViewTasks> createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authController.getUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppColor.tertiaryColor,
        appBar: titleAppBarWithBackButton(
            title: "Tasks",
            subTitle: "Manage Tasks",
            context: context,
            tabBars: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColor.tertiaryColor,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    "All Tasks",
                    style: TextStyle(color: AppColor.tertiaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    "My Tasks",
                    style: TextStyle(color: AppColor.tertiaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    "Manage",
                    style: TextStyle(color: AppColor.tertiaryColor),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () async {
                      await Get.to(() =>
                          ManageSpaceMembers(spaceDocId: widget.spaceDocId,spaces: widget.space,));
                    },
                    icon: const Icon(
                      Icons.people,
                      color: AppColor.tertiaryColor,
                      size: 30.0,
                    )),
              ) ,
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                    onPressed: () async {
                      await Get.to(() =>
                          ChatScreen(spaceDocId: widget.spaceDocId,spaceName: widget.space.spaceName,));
                    },
                    icon: const Icon(
                      Icons.chat,
                      color: AppColor.tertiaryColor,
                      size: 30.0,
                    )),
              )
            ]),

        body: TabBarView(
          children: [
            ///RETURNS ALL TASKS
            allTasks(),

            ///RETURNS MY TASKS - ACCEPTED BY THE CURRENT USER
            myTasks(),

            ///MANAGE TASKS CREATED BY ME
            createdByMeTasks()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => CreateTasks(spaceDocId: widget.spaceDocId));
          },
          backgroundColor: AppColor.primaryColor,
          child: const Icon(
            Icons.add_task,
            color: AppColor.tertiaryColor,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  ///RETURNS ALL THE GROUP TASKS
  allTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("spaces")
          .doc(widget.spaceDocId)
          .collection("tasks")
          .where("taskSelectedTime", isGreaterThanOrEqualTo: DateTime.now())
          .where("status", isEqualTo: 0)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoTasksErrorPage();
        }

        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              const SliverPadding(
                padding: EdgeInsets.only(top: 10),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    QueryDocumentSnapshot? data = snapshot.data?.docs[index];
                    final tasks = Tasks.fromSnapshot(data!);

                    return ListItemViewTasks(
                        tasks: tasks,
                        space: widget.space,
                        spaceDocId: widget.spaceDocId,
                        taskDocId: data.id);
                  },
                  childCount: snapshot.data?.docs.length,
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 40),
              ),
            ],
          );
        }

        if (snapshot.error != null) {
          return NoTasksErrorPage();
        }

        return SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(
                height: 50,
              ),
              ShimmerWidget(),
            ],
          ),
        );
      },
    );
  }

  ///RETURNS TASK WHICH ARE ACCEPTED BY THE USER
  myTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("spaces")
          .doc(widget.spaceDocId)
          .collection("tasks")
          .where("acceptedByEmail", isEqualTo: authController.profile!.email)
          .where("taskSelectedTime", isGreaterThanOrEqualTo: DateTime.now())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoTasksErrorPage();
        }

        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              const SliverPadding(
                padding: EdgeInsets.only(top: 10),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    QueryDocumentSnapshot? data = snapshot.data?.docs[index];
                    final tasks = Tasks.fromSnapshot(data!);

                    return ListItemViewTasks(
                        tasks: tasks,
                        space: widget.space,
                        spaceDocId: widget.spaceDocId,
                        taskDocId: data.id,

                    );
                  },
                  childCount: snapshot.data?.docs.length,
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 40),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(
                height: 50,
              ),
              ShimmerWidget(),
            ],
          ),
        );
      },
    );
  }


  ///RETURNS TASK WHICH ARE ACCEPTED BY THE USER
  createdByMeTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("spaces")
          .doc(widget.spaceDocId)
          .collection("tasks")
          .where("taskByEmail", isEqualTo: authController.profile!.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoTasksErrorPage();
        }

        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              const SliverPadding(
                padding: EdgeInsets.only(top: 10),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    QueryDocumentSnapshot? data = snapshot.data?.docs[index];
                    final tasks = Tasks.fromSnapshot(data!);

                    return ListItemViewTasks(
                      tasks: tasks,
                      space: widget.space,
                      spaceDocId: widget.spaceDocId,
                      taskDocId: data.id,

                    );
                  },
                  childCount: snapshot.data?.docs.length,
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 40),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(
                height: 50,
              ),
              ShimmerWidget(),
            ],
          ),
        );
      },
    );
  }
}

class ListItemViewTasks extends StatefulWidget {
  ListItemViewTasks(
      {Key? key,
      required this.tasks,
      required this.space,
      required this.spaceDocId,
      required this.taskDocId})
      : super(key: key);
  Tasks tasks;
  Spaces space;
  String spaceDocId;
  String taskDocId;

  @override
  State<ListItemViewTasks> createState() => _ListItemViewTasksState();
}

class _ListItemViewTasksState extends State<ListItemViewTasks> {
  late ExpandedTileController expandedController;

  @override
  void initState() {
    // initialize controller
    expandedController = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listItemComponent(tasks: widget.tasks);
  }

  ///RETURNS LIST ITEM VIEW
  Widget listItemComponent({required Tasks tasks}) {
    return GestureDetector(
      onTap: () async {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 10.0,
          child: ListBody(
            children: [
              ///TASK DETAILS
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: const Icon(
                            Icons.task_alt,
                            size: 30.0,
                            color: AppColor.tertiaryColor,
                          ),
                      ),
                    ),
                  ),

                  ///TASK NAME
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: AutoSizeText(
                      tasks.taskName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ///TASK DESCRIPTION
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 5),
                    child: AutoSizeText(
                      tasks.taskDescription,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  trailing: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    width: ScreenSize.height(context) * 0.05,
                    height: ScreenSize.height(context) * 0.05,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          tasks.taskByImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),

              ///TASK DATE & TIME
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  const Icon(
                    Icons.timer,
                    size: 40.0,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  AutoSizeText(
                    DateFormat('dd-MM-yyyy  kk:mm a')
                        .format(tasks.taskSelectedStartTime.toDate()),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 10.0,
              ),

              ///TASK POINTS
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  const Icon(
                    Icons.star,
                    size: 40.0,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  AutoSizeText(
                    "${tasks.taskTotalPoints} Points",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),

              ///ACCEPT/DECLINE TASK
              ///CHECKS IF THE TASK POSTED BY THE CURRENT USER - ALLOWS USER TO CANCEL A TASK
              tasks.taskByEmail == authController.profile!.email
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///ACCEPT TASK
                        SizedBox(
                          height: 75.0,
                          width: 75.0,
                          child: IconButton(
                            onPressed: () {
                              ///MARKS THE TASK AS ACCEPTED
                              tasks.taskByEmail == authController.profile!.email ?
                              showToast("You can not accept a task created by you", ToastGravity.BOTTOM)
                              : yesNoDialog(
                                  context: context,
                                  text:
                                      "Are you sure you want to accept the task?",
                                  onTap: () {
                                    ///UPDATE TASK DETAILS AS ACCEPTED
                                    taskController.updateTaskDetails(
                                        spaceDocId: widget.spaceDocId,
                                        taskDocId: widget.taskDocId,
                                        status: 1,
                                        task: tasks);
                                  });
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: AppColor.green,
                              size: 50.0,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 75.0,
                        ),

                        ///CANCEL TASK
                        SizedBox(
                          height: 75.0,
                          width: 75.0,
                          child: IconButton(
                            onPressed: () {
                              ///MARKS THE TASK AS ACCEPTED
                              yesNoDialog(
                                  context: context,
                                  text:
                                      "Are you sure you want to delete the task?",
                                  onTap: () {
                                    taskController.updateTaskDetails(
                                        spaceDocId: widget.spaceDocId,
                                        taskDocId: widget.taskDocId,
                                        status: 3,
                                        task: tasks);
                                  });
                            },
                            tooltip: "DECLINE TASK",
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColor.red,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  : tasks.status == 0
                      ?

                      ///ACCEPT TASK SLIDER BUTTON
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                              child: SliderButton(
                                  action: () {
                                    ///MARKS THE TASK AS ACCEPTED
                                    taskController.updateTaskDetails(
                                        spaceDocId: widget.spaceDocId,
                                        taskDocId: widget.taskDocId,
                                        status: 1,
                                        task: tasks);
                                  },
                                  label: const Text(
                                    "Slide to Accept Task",
                                    style: TextStyle(
                                        color: Color(0xff4a4a4a),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                  width: ScreenSize.width(context) * 0.75,
                                  buttonColor: AppColor.primaryColor,
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: AppColor.white,
                                    size: 30.0,
                                  ))),
                        )
                      : tasks.status == 1
                          ?
                          ///COMPLETE TASK SLIDER BUTTON
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                  child: SliderButton(
                                      action: () {
                                        ///MARKS THE TASK AS COMPLETED
                                        taskController.updateTaskDetails(
                                            spaceDocId: widget.spaceDocId,
                                            taskDocId: widget.taskDocId,
                                            status: 2,
                                            task: tasks);

                                        ///UPDATES POINTS FOR ALL THE USERS
                                        taskController.updatePointsDetails(spaces: widget.space, task: tasks);

                                      },
                                      label: const Text(
                                        "Slide to Complete Task",
                                        style: TextStyle(
                                            color: Color(0xff4a4a4a),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      width: ScreenSize.width(context) * 0.75,
                                      buttonColor: AppColor.primaryColor,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: AppColor.white,
                                        size: 40.0,
                                      ))),
                            )
                          : const SizedBox(height: 15.0)
            ],
          ),
        ),
      ),
    );
  }
}

//ERROR PAGE - SHOWING NO USERS ERROR
class NoTasksErrorPage extends StatefulWidget {
  const NoTasksErrorPage({Key? key}) : super(key: key);

  @override
  State<NoTasksErrorPage> createState() => _NoTasksErrorPageState();
}

class _NoTasksErrorPageState extends State<NoTasksErrorPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: ScreenSize.height(context) * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.task_alt,
                  size: 100,
                  color: AppColor.primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 60),
                  child: Text(
                    'NO TASKS FOUND',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColor.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
