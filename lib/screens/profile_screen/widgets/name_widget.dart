import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';

class NameWidget extends StatelessWidget {
  final TextEditingController nameController;
  final String helperText;
  final String emptyErrorMsg;
  const NameWidget(
      {super.key,
      required this.nameController,
      required this.helperText,
      required this.emptyErrorMsg});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '*',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.negativeLight,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: helperText,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.greys60,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        enabledBorder: _outline(AppColors.grey40),
        focusedBorder: _outline(AppColors.grey40),
        errorBorder: _outline(AppColors.negativeLight),
        focusedErrorBorder: _outline(AppColors.negativeLight),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      ),
      validator: (String? value) {
        if (value != null) {
          if (value.isEmpty) {
            return emptyErrorMsg;
          } else if (!RegExpressions.alphabetsWithDot.hasMatch(value)) {
            return AppLocalizations.of(context)!.nameWithoutSp;
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.text,
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
