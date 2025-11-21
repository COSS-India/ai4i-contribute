import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/branding_config.dart';
import '../../../../constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.enterMobileNumber,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            color: AppColors.grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Container(
              height: 48.w,
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey40),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '+91',
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: '+91', child: Text('+91')),
                  ],
                  onChanged: (value) {},
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    color: AppColors.greys87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.greys87,
                    size: 20.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 48.w,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.dark,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: BrandingConfig.instance.getPrimaryTextStyle(
                      color: AppColors.grey40,
                      fontSize: 14.sp,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.grey40),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.lightGreen),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.negativeLight),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.negativeLight),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.w,
                    ),
                  ),
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    color: AppColors.greys87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
