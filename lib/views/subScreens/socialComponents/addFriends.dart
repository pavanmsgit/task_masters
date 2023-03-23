import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/socialController.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/views/subScreens/socialScreen.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appButtons.dart';
import 'package:task_masters/widgets/shimmer.dart';
import 'package:task_masters/widgets/toastMessage.dart';
import '../../../../models/userModel.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authController.getUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: titleAppBarWithBackButton(
          title: "Add Friends",
          subTitle: "Manage Friends",
          context: context,
        ),
        backgroundColor: AppColor.white,
        body: allUsers());
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
                    final usersMain = UserModel.fromSnapshot(data!);
                    //return ListItemViewTasks(users: users);

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(authController.profile!.email)
                            .collection("friends")
                            .snapshots(),

                        builder: (context, snap){

                          if (snap.data?.docs.length == 0) {
                            return NoUsersErrorPage();
                          }


                          if (snap.hasData) {
                            return Container(
                              height: ScreenSize.height(context),
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  const SliverPadding(
                                    padding: EdgeInsets.only(top: 10),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        QueryDocumentSnapshot? dataAlt = snap.data?.docs[index];
                                        final users = UserModel.fromSnapshot(dataAlt!);

                                        return snap.data!.docs.isEmpty ?
                                           const NoFriendsErrorPage()
                                           : usersMain.email == users.email
                                            ? ListItemViewTasks(users: usersMain) :
                                            Container(height: 1,);
                                      },
                                      childCount: snapshot.data!.docs.length,
                                    ),
                                  ),
                                  const SliverPadding(
                                    padding: EdgeInsets.only(bottom: 40),
                                  ),
                                ],
                              ),
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
                        });
                  },
                  childCount: snapshot.data?.docs.length,
                ),
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
  ListItemViewTasks({Key? key, required this.users}) : super(key: key);
  UserModel users;

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
      builder: (_) => GestureDetector(
        onTap: () async {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 10.0,
            child: ListBody(
              children: [
                ///USERS DETAILS
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        color: AppColor.white,
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

                    ///USER NAME
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

                    ///USER EMAIL
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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  child: TaskMastersButton(
                      buttonText: "Add Friend",
                      onTap: () async {
                        await socialController.addFriend(user: users);
                      }),
                )
              ],
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
