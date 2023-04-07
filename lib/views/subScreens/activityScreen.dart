import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/taskController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/models/tasks.dart';
import 'package:task_masters/views/subScreens/spacesComponents/createSpace.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/createTasks.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appDialogs.dart';
import 'package:task_masters/widgets/shimmer.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key,required this.backButton}) : super(key: key);
  final bool backButton;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppColor.tertiaryColor,
        appBar: widget.backButton ?
        titleAppBarWithBackButton(
          title: 'Activity History',
          subTitle: '',
          context: context,
          tabBars: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColor.tertiaryColor,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text(
                  "Completed",
                  style: TextStyle(color: AppColor.tertiaryColor),
                ),
              ),
              Tab(
                child: Text(
                  "Pending",
                  style: TextStyle(color: AppColor.tertiaryColor),
                ),
              ),
            ],
          ),
        ) :
        titleAppBar(
          context: context,
          tabBars: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColor.tertiaryColor,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text(
                  "Completed",
                  style: TextStyle(color: AppColor.tertiaryColor),
                ),
              ),
              Tab(
                child: Text(
                  "Pending",
                  style: TextStyle(color: AppColor.tertiaryColor),
                ),
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ///RETURNS ALL TASKS
            completedTasks(),

            ///RETURNS MY TASKS - ACCEPTED BY THE CURRENT USER
            pendingTasks()
          ],
        ),
      ),
    );
  }

  ///RETURNS ALL THE GROUP TASKS
  completedTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tasksOverall")
          .where("acceptedByEmail", isEqualTo: authController.profile!.email)
          .where("status", isEqualTo: 2)
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
                        tasks: tasks, taskOverallDocId: data.id);
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
  pendingTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tasksOverall")
          .where("acceptedByEmail", isEqualTo: authController.profile!.email)
          .where("status", isEqualTo: 1)
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
                        tasks: tasks, taskOverallDocId: data.id);
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
                height: 10,
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
      {Key? key, required this.tasks, required this.taskOverallDocId})
      : super(key: key);
  Tasks tasks;
  String taskOverallDocId;

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
        child: Row(
          children: [

            SizedBox(
              width: ScreenSize.width(context) * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Icon(
                      widget.tasks.spaceTask! ? Icons.people : Icons.person,
                      size: 50.0,
                      color: AppColor.primaryColor,
                    )),
              ),
            ),

            SizedBox(
              width: ScreenSize.width(context) * 0.75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 10.0,
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
                          child: Icon(
                            widget.tasks.status == 2 ? Icons.task_alt_outlined : Icons.timer,
                            size: 30.0,
                            color: AppColor.white,
                          )),
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

                  ///TASK POINTS
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 5),
                    child: AutoSizeText(
                      "${tasks.taskTotalPoints} Points",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  trailing: Container(
                    color: AppColor.white,
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
            ),
          ],
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
