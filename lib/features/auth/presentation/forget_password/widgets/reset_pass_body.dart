import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:medigo/core/components/buttons/main_button.dart';
import 'package:medigo/core/components/inputs/main_text_form_field.dart';
import 'package:medigo/core/utils/colors.dart';
import 'package:medigo/core/utils/fonts.dart';

class ResetPassBody extends StatelessWidget {
  const ResetPassBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Password",
              style: AppFontStyles.getSize32(fontWeight: FontWeight.w500),
            ),
            Gap(15),
            Text(
              style: AppFontStyles.getSize14(
                fontColor: AppColors.slateGrayColor,
              ),
              "Set the new password for your account so you can login and access all the features.",
            ),
            Gap(45),
            MainTextFormField(
              label: "New Password",
              ispassword: true,
              colorFill: Colors.transparent,
            ),
            Gap(20),
            MainTextFormField(
              label: "Confirm Password",
              ispassword: true,
              colorFill: Colors.transparent,
            ),
            Gap(60),
            Center(
              child: MainButton(
                buttonText: "Update Password",
                onPressed: () {},
                width: 295,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
