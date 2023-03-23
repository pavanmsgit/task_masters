import 'package:flutter/material.dart';
import 'package:task_masters/const/appColors.dart';

Future<bool> onWillPop(BuildContext context) async {
  bool? exitResult = await showExitBottomSheet(context);
  return exitResult ?? false;
}

showExitBottomSheet(BuildContext context) async {
  return await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: buildBottomSheet(context),
      );
    },
  );
}

Widget buildBottomSheet(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(
        height: 24,
      ),
      const Text(
        'Do you want to exit an App?',
          style: TextStyle(color: AppColor.blackMild,fontSize: 18)
      ),
      const SizedBox(
        height: 24,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL',style: TextStyle(color: AppColor.primaryColor)),
          ),
          TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('YES, EXIT',style: TextStyle(color: AppColor.primaryColor),),
          ),
        ],
      ),
    ],
  );
}



