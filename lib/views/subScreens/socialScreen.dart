import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:task_masters/views/subScreens/socialComponents/addFriends.dart';
import 'package:task_masters/views/subScreens/spacesComponents/createSpace.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/createTasks.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/selectAndAddMembers.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/appDialogs.dart';
import 'package:task_masters/widgets/shimmer.dart';

import '../../../../models/userModel.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key})
      : super(key: key);


  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
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
        appBar: titleAppBar(context: context),
        backgroundColor: AppColor.tertiaryColor,
        body: allSpaceUsers(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const AddFriends());
          },
          backgroundColor: AppColor.primaryColor,
          child: const Icon(
            Icons.person_add,
            color: AppColor.white,
            size: 30.0
          ),
        )
    );
  }

  ///RETURNS ALL THE GROUP TASKS
  allSpaceUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(authController.profile!.email)
          .collection("friends")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return NoFriendsErrorPage();
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
                        users: users);
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
          return NoFriendsErrorPage();
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
        required this.users})
      : super(key: key);
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
    return GestureDetector(
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
              ///TASK DETAILS
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  ///USER PHOTO
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

                  ///REMOVE USER FROM THE SPACE
                  // trailing: IconButton(onPressed: (){
                  // //REMOVES USER FROM THE SPACE
                  // },
                  //   icon: const Icon(Icons.remove_circle,color: AppColor.red,size: 20.0,)
                  // )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//ERROR PAGE - SHOWING NO USERS ERROR
class NoFriendsErrorPage extends StatefulWidget {
  const NoFriendsErrorPage({Key? key}) : super(key: key);

  @override
  State<NoFriendsErrorPage> createState() => _NoFriendsErrorPageState();
}

class _NoFriendsErrorPageState extends State<NoFriendsErrorPage> {
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
                    'NO FRIENDS FOUND',
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
