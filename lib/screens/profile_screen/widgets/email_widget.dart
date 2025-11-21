import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';

class EmailWidget extends StatelessWidget {
  final TextEditingController emailController;
  const EmailWidget({super.key, required this.emailController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.emailId,
        labelStyle: BrandingConfig.instance
            .getPrimaryTextStyle(color: AppColors.greys60, fontSize: 14.sp),
        enabledBorder: _outline(AppColors.darkGrey),
        focusedBorder: _outline(AppColors.darkGrey),
        errorBorder: _outline(AppColors.negativeLight),
        focusedErrorBorder: _outline(AppColors.negativeLight),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (value != null && value.isNotEmpty) {
          String? matchedString = RegExpressions.validEmail.stringMatch(value);
          if (matchedString == null ||
              matchedString.isEmpty ||
              matchedString.length != value.length) {
            return AppLocalizations.of(context)!.enterValidEmail;
          }
          return null;
        } else {
          return null;
        }
      },
      style: BrandingConfig.instance.getPrimaryTextStyle(
          color: AppColors.greys87,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500),
    );
  }

  InputBorder _outline(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: color),
      );
}
