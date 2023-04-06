import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/models/spaces.dart';
import 'package:task_masters/views/subScreens/spacesComponents/createSpace.dart';
import 'package:task_masters/views/subScreens/spacesComponents/tasks/viewTasks.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:get/get.dart';
import 'package:task_masters/widgets/shimmer.dart';

class SpacesScreen extends StatefulWidget {
  const SpacesScreen({Key? key}) : super(key: key);

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("spaces")
            .where("spaceUsers", arrayContains: authController.profile!.email)
            .limit(100)
            .snapshots(),


        builder: (context, snapshot) {
          if (snapshot.data?.docs.length == 0) {
            return const NoSpacesErrorPage();
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
                      final spaces = Spaces.fromSnapshot(data!);

                      return ListItemViewUsers(
                          spaces: spaces, spaceDocId: data.id);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateSpace());
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.add,
          color: AppColor.tertiaryColor,
          size: 30.0,
        ),
      ),
    );
  }
}

class ListItemViewUsers extends StatefulWidget {
  const ListItemViewUsers(
      {Key? key, required this.spaces, required this.spaceDocId})
      : super(key: key);
  final Spaces spaces;
  final String spaceDocId;

  @override
  State<ListItemViewUsers> createState() => _ListItemViewUsersState();
}

class _ListItemViewUsersState extends State<ListItemViewUsers> {
  late ExpandedTileController expandedController;

  @override
  void initState() {
    // initialize controller
    expandedController = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listItemComponent(spaces: widget.spaces);
  }

  ///RETURNS LIST ITEM VIEW
  Widget listItemComponent({required Spaces spaces}) {
    return GestureDetector(
      onTap: () async {
        await Get.to(
            () => ViewTasks(spaceDocId: widget.spaceDocId, space: spaces));
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
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ListTile(
                  isThreeLine: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  leading: spaces.spaceImage.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColor.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Icon(
                                Icons.people,
                                size: 35.0,
                                color: AppColor.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColor.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                          width: ScreenSize.height(context) * 0.075,
                          height: ScreenSize.height(context) * 0.15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(
                              spaces.spaceImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                  ///SPACE NAME
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: AutoSizeText(
                      spaces.spaceName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white
                      ),
                    ),
                  ),

                  ///SPACE DESCRIPTION - SPACE CAPACITY
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 5),
                    child: AutoSizeText(
                      "${spaces.spaceDescription}\nSpace Capacity : ${spaces.spaceCapacity}" ??
                          "",
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                          color: AppColor.white

                      ),
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    width: ScreenSize.height(context) * 0.05,
                    height: ScreenSize.height(context) * 0.05,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          spaces.spaceAdminImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//ERROR PAGE - SHOWING NO SPACES ERROR
class NoSpacesErrorPage extends StatefulWidget {
  const NoSpacesErrorPage({Key? key}) : super(key: key);

  @override
  State<NoSpacesErrorPage> createState() => _NoSpacesErrorPageState();
}

class _NoSpacesErrorPageState extends State<NoSpacesErrorPage> {
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
                    'NO SPACES FOUND',
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
