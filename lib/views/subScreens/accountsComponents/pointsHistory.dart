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
import 'package:task_masters/models/points.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/models/tasks.dart';
import 'package:task_masters/views/subScreens/spacesComponents/createSpace.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/createTasks.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appDialogs.dart';
import 'package:task_masters/widgets/shimmer.dart';

class PointsHistory extends StatefulWidget {
  const PointsHistory({Key? key}) : super(key: key);

  @override
  State<PointsHistory> createState() => _PointsHistoryState();
}

class _PointsHistoryState extends State<PointsHistory> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authController.getUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
        titleAppBarWithBackButton(
          title: 'Points',
          subTitle: 'History of Points Added/Removed',
          context: context,
        ),
        backgroundColor: AppColor.tertiaryColor,
        body: pointsHistoryList(),
      ),
    );
  }

  ///RETURNS ALL THE GROUP TASKS
  pointsHistoryList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("points")
          .where("email", isEqualTo: authController.profile!.email)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoPointsHistoryErrorPage();
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
                    final points = Points.fromSnapshot(data!);

                    return ListItemViewTasks(
                        points: points);
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
          return NoPointsHistoryErrorPage();
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
      {Key? key, required this.points})
      : super(key: key);
  Points points;

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
    return listItemComponent(points: widget.points);
  }

  ///RETURNS LIST ITEM VIEW
  Widget listItemComponent({required Points points}) {
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
                      widget.points.points > 0 ? Icons.add_circle : Icons.remove_circle,
                      size: 50.0,
                      color: AppColor.primaryColor,
                    )),
              ),
            ),

            SizedBox(
              width: ScreenSize.width(context) * 0.75,
              child: Card(
                color: AppColor.white.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 10.0,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),


                  ///POINTS MESSAGE
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: AutoSizeText(
                      widget.points.points > 0 ? "${points.points} Points were Added" : "${points.points} Points were Removed"  ,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ///POINTS TIMESTAMP
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: AutoSizeText(
                      "On ${DateFormat('dd MMM yyyy - hh:mm a').format(widget.points.referenceTimestamp.toDate())}",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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

//ERROR PAGE - SHOWING NO POINTS HISTORY
class NoPointsHistoryErrorPage extends StatefulWidget {
  const NoPointsHistoryErrorPage({Key? key}) : super(key: key);

  @override
  State<NoPointsHistoryErrorPage> createState() => _NoPointsHistoryErrorPageState();
}

class _NoPointsHistoryErrorPageState extends State<NoPointsHistoryErrorPage> {
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
                  Icons.money,
                  size: 100,
                  color: AppColor.primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 60),
                  child: Text(
                    'NO POINTS HISTORY',
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
