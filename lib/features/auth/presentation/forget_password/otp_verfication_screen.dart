import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:medigo/core/utils/colors.dart';
import 'package:medigo/core/utils/fonts.dart';
import 'package:medigo/features/auth/presentation/widgets/otp_input_fields.dart';

class OtpVerficationScreen extends StatelessWidget {
  const OtpVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter 4 Digits Code",
                style: AppFontStyles.getSize32(fontWeight: FontWeight.w500),
              ),
              Gap(20),
              Text(
                "Enter the 4 digits code that you received onyour email.",
                style: AppFontStyles.getSize16(
                  fontColor: AppColors.slateGrayColor,
                ),
              ),

               OtpInputFields(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the code";
                      }
                      if (value.length < 6) {
                        return "Code must be 6 digits";
                      }
                      return null;
                    },
                  ),

            ],
          ),
        ),
      ),
    );
  }
}
