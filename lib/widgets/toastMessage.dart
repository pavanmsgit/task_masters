import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_masters/const/appColors.dart';

///SHOWS A TOAST MESSAGE
showToast(String message, ToastGravity gravity) {
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: AppColor.primaryColor,
    gravity: gravity,
    textColor: AppColor.white,
    fontSize: 15,
    toastLength: Toast.LENGTH_SHORT,
  );
}
