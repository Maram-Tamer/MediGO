// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:medigo/core/utils/colors.dart';
import 'package:medigo/core/utils/fonts.dart';

// ignore: must_be_immutable
class MainTextFormField extends StatefulWidget {
  MainTextFormField({
    super.key,
    required this.controller,
    this.textFormFieldText,
    this.maxTextLines = 1,
    this.validator,
    required this.ispassword,
  });
  bool ispassword = false;
  String? Function(String?)? validator;
  int maxTextLines;
  String? textFormFieldText;
  final TextEditingController controller;

  @override
  State<MainTextFormField> createState() => _MainTextFormFieldState();
}

class _MainTextFormFieldState extends State<MainTextFormField> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.ispassword && isObsecure,
      validator: widget.validator,
      controller: widget.controller,
      maxLines: widget.maxTextLines,
      style: AppFontStyles.getSize18(),
      decoration: InputDecoration(
        suffixIcon: widget.ispassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                child: Icon(
                  isObsecure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
        hint: Text(
          widget.textFormFieldText ?? "",
          style: AppFontStyles.getSize18(fontColor: AppColors.greyColor),
        ),
      ),
    );
  }
}
