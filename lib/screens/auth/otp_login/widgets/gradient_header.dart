import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/branding_config.dart';
import '../../../../constants/app_colors.dart';

class GradientHeader extends StatelessWidget {
  final String title;

  const GradientHeader({
    super.key,
    this.title = "Login",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16).r,
      decoration: BoxDecoration(color: AppColors.orange),
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_circle_left_outlined,
                color: Colors.white,
                size: 36.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
