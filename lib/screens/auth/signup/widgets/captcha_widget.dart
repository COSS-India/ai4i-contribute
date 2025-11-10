import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/branding_config.dart';
import '../../../../constants/app_colors.dart';

class CaptchaWidget extends StatefulWidget {
  final String captchaText;
  final VoidCallback onRefresh;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const CaptchaWidget({
    super.key,
    required this.captchaText,
    required this.onRefresh,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // CAPTCHA Image Container
            Container(
              width: 120.w,
              height: 48.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(6.r),
                color: AppColors.lightGrey.withValues(alpha: 0.3),
              ),
              child: Center(
                child: Text(
                  widget.captchaText,
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greys87,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Refresh Button
            GestureDetector(
              onTap: widget.onRefresh,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.refresh,
                  color: AppColors.grey40,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // CAPTCHA Input Field
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: TextFormField(
                  controller: _controller,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    labelText: '*Enter CAPTCHA',
                    labelStyle: BrandingConfig.instance.getPrimaryTextStyle(
                      color: AppColors.greys87,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: AppColors.darkBlue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: AppColors.negativeLight),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: AppColors.negativeLight),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    color: AppColors.greys87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) {
                    widget.onChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
