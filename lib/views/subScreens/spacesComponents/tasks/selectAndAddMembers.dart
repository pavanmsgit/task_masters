import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appButtons.dart';
import 'package:task_masters/widgets/shimmer.dart';
import 'package:task_masters/widgets/toastMessage.dart';
import '../../../../models/userModel.dart';

class SelectAndAddMembers extends StatefulWidget {
  const SelectAndAddMembers(
      {Key? key, required this.spaceDocId, required this.spaces})
      : super(key: key);
  final String spaceDocId;
  final Spaces spaces;

  @override
  State<SelectAndAddMembers> createState() => _SelectAndAddMembersState();
}

class _SelectAndAddMembersState extends State<SelectAndAddMembers> {

  

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authController.getUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => spacesController.clearSpaceUserList(),
      child: Scaffold(
        backgroundColor: AppColor.tertiaryColor,

        appBar: titleAppBarWithBackButton(
            title: "Task Master Users",
            subTitle: "Current Space Capacity : ${spacesController.currentCapacity.value}",
            context: context,
            onPress: () {
              spacesController.clearSpaceUserList();
            }),
        body: allUsers(),
        bottomNavigationBar: Obx(
              () => spacesController.addUsersButtonStatus.value
              ? Container(
            height: 0.1,
          )
              : Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50,
              child: TaskMastersButton(
                  buttonText: "Add Users",
                  onTap: () {

                    ///CHECKS SPACE AVAILABLE CAPACITY AND ADDS USERS
                    spacesController.currentCapacity.value < spacesController.spaceUsersList.length
                        ? showToast(
                        "Space capacity full",
                        ToastGravity.CENTER)
                        : spacesController.updateSpaceUsers(
                        spaceDocId: widget.spaceDocId, space: widget.spaces);
                  }),
            ),
          ),
        ),
      ),
    );
  }

  ///RETURNS ALL THE GROUP TASKS
  allUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where("email", isNotEqualTo: authController.profile!.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoUsersErrorPage();
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
                    final users = UserModel.fromSnapshot(data!);

                    return ListItemViewTasks(
                        users: users, spaceDocId: widget.spaceDocId);
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
          return NoUsersErrorPage();
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
  ListItemViewTasks({Key? key, required this.users, required this.spaceDocId})
      : super(key: key);
  UserModel users;
  String spaceDocId;

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
    return listItemComponent(users: widget.users);
  }

  ///RETURNS LIST ITEM VIEW
  Widget listItemComponent({required UserModel users}) {
    RxBool isSelected = false.obs;

    return GetBuilder(
      init: SpacesController(),
      builder: (_) => Obx(
        () => GestureDetector(
          onTap: () async {
            if (isSelected.value == false) {
              isSelected.value = true;
              spacesController.addToSpaceUserList(user: users);
            } else {
              isSelected.value = false;
              spacesController.removeFromSpaceUserList(user: users);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: AppColor.white.withOpacity(0.4),
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
                          leading: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                             decoration: BoxDecoration(
                               color: AppColor.white.withOpacity(0.4),
                               borderRadius: BorderRadius.circular(60.0),
                             ),
                              height: ScreenSize.height(context) * 0.1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.network(
                                  users.profileImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          ///TASK NAME
                          title: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: AutoSizeText(
                              users.name,
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
                              users.email,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          ///REMOVE USER FROM THE SPACE
                          trailing: Icon(
                            Icons.check_circle,
                            color: isSelected.value == true
                                ? AppColor.primaryColor
                                : AppColor.blackMild.withOpacity(0.5),
                            size: 30.0,
                          ),),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//ERROR PAGE - SHOWING NO USERS ERROR
class NoUsersErrorPage extends StatefulWidget {
  const NoUsersErrorPage({Key? key}) : super(key: key);

  @override
  State<NoUsersErrorPage> createState() => _NoUsersErrorPageState();
}

class _NoUsersErrorPageState extends State<NoUsersErrorPage> {
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
                  Icons.people,
                  size: 100,
                  color: AppColor.primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 60),
                  child: Text(
                    'NO USERS FOUND',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackMild),
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
