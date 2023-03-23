import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_masters/const/appColors.dart';
import 'package:task_masters/const/screen_size.dart';

// ignore: must_be_immutable
class TitleTextField extends StatelessWidget {
  TitleTextField(
      {Key? key,
        required this.title,
        this.keyboardType,
        this.customHeight,
        this.controller,
        this.padding,
        this.icon,
        this.iconData,
        this.enabled = true,
        this.hint = '',
        this.onChanged,
        this.validator,
        this.iconTap,
        this.node,
        this.onSubmit,
        this.obscure = false,
        this.maxLength,
        this.cursorColor,
        this.textColor,
        this.hintTextColor,
        this.len,
        this.textSize,
        this.maxLines,
        this.hintTextSize,
        this.showTitle
      })
      : super(key: key);

  final String title;
  TextEditingController? controller;
  TextInputType? keyboardType;
  double? customHeight, padding;
  Icon? icon;
  IconData? iconData;
  bool enabled;
  String hint;
  Function(String?)? onChanged;
  Function()? iconTap;
  String? Function(String?)? validator;
  bool obscure;
  FocusNode? node;
  Function(String)? onSubmit;
  int? maxLength;
  Color? cursorColor;
  Color? textColor;
  Color? hintTextColor;
  double? textSize;
  double? hintTextSize;
  int? len;
  int? maxLines;
  bool? showTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: padding == 0 ? 0 : 5),
          showTitle == true ?  Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryColor
            ),
          ) : Container(),
          CustomTextField(
            customHeight: customHeight,
            keyboardType: keyboardType,
            controller: controller,
            hintText: hint,
            icon: icon,
            iconData: iconData,
            enabled: enabled,
            onChanged: onChanged,
            validator: validator,
            iconTap: iconTap,
            obscure: obscure,
            node: node,
            onSubmit: onSubmit,
            maxLength: maxLength,
            cursorColor: cursorColor,
            textColor: textColor,
            hintTextColor: hintTextColor,
            len: len,
            textSize: textSize,
            hintTextSize: hintTextSize,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
        this.keyboardType,
        this.customHeight,
        this.padding,
        this.hintText = '',
        this.enabled = true,
        this.controller,
        this.icon,
        this.iconData,
        this.iconTap,
        this.obscure = false,
        this.onChanged,
        this.validator,
        this.node,
        this.onSubmit,
        this.maxLength,
        this.cursorColor,
        this.hintTextColor,
        this.textColor,
        this.len,
        this.maxLines,
        this.textSize,
        this.hintTextSize})
      : super(key: key);

  TextInputType? keyboardType;
  String? hintText;
  bool? enabled;
  TextEditingController? controller;
  double? customHeight, padding;
  Icon? icon;
  IconData? iconData;
  Function()? iconTap;
  Function(String?)? onChanged;
  String? Function(String?)? validator;
  bool obscure;
  FocusNode? node;
  Function(String)? onSubmit;
  int? maxLength;
  Color? cursorColor;
  Color? textColor;
  double? textSize;
  Color? hintTextColor;
  double? hintTextSize;
  int? len;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: customHeight ?? ScreenSize.height(context) * 0.05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.greyLight.withOpacity(0.5)
      ),
      child: TextFormField(
        //maxLengthEnforcement: ,
        maxLength: maxLength,
        inputFormatters: [
          LengthLimitingTextInputFormatter(len),
        ],
        cursorColor: cursorColor,
        maxLines: maxLines ?? 1,
        enabled: enabled,
        focusNode: node,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onSubmit,
        style: TextStyle(fontSize: textSize ?? 15, color: textColor),
        obscureText: obscure,
        keyboardType: keyboardType ?? TextInputType.name,
        decoration: InputDecoration(
          //icon: icon,
          prefixIcon: icon,
          fillColor: AppColor.primaryColor,
          //prefixIconConstraints: const BoxConstraints(maxHeight: double.infinity,maxWidth: double.infinity),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: hintTextSize ?? 15,
            color: hintTextColor,
          ),
          suffixIcon: iconData != null
              ? IconButton(
            onPressed: iconTap,
            icon: Icon(
              iconData,
              size: 22,
              color: AppColor.primaryColor,
            ),
          )
              : const SizedBox(
            height: 0,
            width: 0,
          ),
        ),
      ),
    );
  }
}


