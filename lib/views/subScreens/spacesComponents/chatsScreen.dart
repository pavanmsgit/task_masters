import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';
import 'package:task_masters/controllers/authController.dart';
import 'package:task_masters/controllers/spacesController.dart';
import 'package:task_masters/models/chats.dart';
import 'package:task_masters/widgets/appBars.dart';
import 'package:task_masters/widgets/shimmer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.spaceDocId,
    required this.spaceName,
  }) : super(key: key);
  final String spaceDocId;
  final String spaceName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: titleAppBarWithBackButton(
          title: "Space Chats",
          subTitle: widget.spaceName,
          context: context),
      backgroundColor: AppColor.tertiaryColor,
      body: GetBuilder(
        init: SpacesController(),
        builder: (_) => groupChats(),
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        color: AppColor.primaryColor,
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: AppColor.tertiaryColor,),
                    border: InputBorder.none),
                style: const TextStyle(color: AppColor.tertiaryColor,),
                controller: spacesController.chatsController,
                cursorColor: AppColor.tertiaryColor,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                spacesController.sendMessage(spaceDocId: widget.spaceDocId);
              },
              backgroundColor: AppColor.tertiaryColor,
              elevation: 0,
              child: const Icon(
                Icons.send,
                color: AppColor.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget groupChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("spaces")
          .doc(widget.spaceDocId)
          .collection("messages")
          .orderBy("referenceTimestamp")
          .snapshots(),
      builder: (context, snapshot) {
        //var orderItems = snapshot.data?.docs;
        if (snapshot.data?.docs.length == 0) {
          return const NoChats();
        }

        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              const SliverPadding(padding: EdgeInsets.only(top: 10.0)),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    QueryDocumentSnapshot? data = snapshot.data?.docs[index];
                    final chatsItem = Chats.fromSnapshot(data!);

                    return ListBodyForPurchaseRequest(
                        chats: chatsItem, docId: data.id);
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

        return const ShimmerWidget();
      },
    );
  }
}

///LIST OF PURCHASE REQUESTS
class ListBodyForPurchaseRequest extends StatefulWidget {
  ListBodyForPurchaseRequest(
      {Key? key, required this.chats, required this.docId})
      : super(key: key);
  Chats chats;
  String docId;

  @override
  State<ListBodyForPurchaseRequest> createState() =>
      _ListBodyForPurchaseRequestState();
}

class _ListBodyForPurchaseRequestState
    extends State<ListBodyForPurchaseRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListBody(
        children: [
          Container(
              alignment:
                  widget.chats.email == authController.profile!.email
                      ? Alignment.topRight
                      : Alignment.topLeft,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5, bottom: 5),
              margin: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: widget.chats.email ==
                        authController.profile!.email
                    ? AppColor.primaryColor
                    : AppColor.greyLight,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              ),
              child: ListTile(
                leading: widget.chats.email !=
                        authController.profile!.email
                    ? Container(
                        width: ScreenSize.height(context) * 0.05,
                        height: ScreenSize.height(context) * 0.05,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              widget.chats.profileImage!,
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(width: 1,),


                trailing: widget.chats.email ==
                        authController.profile!.email
                    ? Container(
                        width: ScreenSize.height(context) * 0.05,
                        height: ScreenSize.height(context) * 0.05,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              widget.chats.profileImage!,
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(width: 1,),



                title: Text(
                  widget.chats.message,
                  textAlign: widget.chats.email ==
                          authController.profile!.email
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black),
                ),
              )),


          Container(
              alignment:
                  widget.chats.email == authController.profile!.email
                      ? Alignment.topRight
                      : Alignment.topLeft,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0, bottom: 0),
              margin: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0, bottom: 0),
              decoration: const BoxDecoration(
                color: AppColor.tertiaryColor,
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              child: Text(
               "By ${widget.chats.name} at ${DateFormat('hh:mm a').format(widget.chats.referenceTimestamp.toDate())}",
                style: const TextStyle(fontSize: 10, color: AppColor.white),
              ),
          ),
        ],
      ),
    );
  }
}

//ERROR PAGE - SHOWING NO COST ITEMS ADDED ERROR
class NoChats extends StatelessWidget {
  const NoChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.message,
                size: 100,
                color: AppColor.primaryColor,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 60),
                child: Text(
                  'NO MESSAGES',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColor.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
