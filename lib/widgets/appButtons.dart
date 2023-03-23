import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';


///SELECT IMAGE BUTTON - CALLS SELECT IMAGE METHOD
class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.image,
  }) : super(key: key);
  final String title;
  final Function() onTap;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.primaryColor
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: GestureDetector(
                onTap: onTap,
                child: image == null
                    ? SizedBox(
                  height: ScreenSize.width(context) * 0.9,
                  width: ScreenSize.width(context) * 0.9,
                  child: Column(
                    children: const [
                       Icon(
                        Icons.add_photo_alternate,
                        size: 100,
                        color: AppColor.secondaryColor,
                      ),

                      AutoSizeText(
                        "Click here to add picture",
                        style:  TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.grey
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey, width: 3.0),
                    color: AppColor.grey,
                  ),
                  child: Image.file(
                    image!,
                    fit: BoxFit.fill,
                    height: 200,
                    width: ScreenSize.width(context) * 0.9,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}



class TaskMastersButton extends StatelessWidget {
  const TaskMastersButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);
  final String buttonText;
  final Function() onTap;
  final Color? buttonColor, textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,

      style: ButtonStyle(

        minimumSize: MaterialStateProperty.all(
          Size(0, ScreenSize.height(context) * 0.06),
        ),
        backgroundColor: MaterialStateProperty.all(buttonColor ?? AppColor.primaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
