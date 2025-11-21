import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const GetStartedItem({super.key, 
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ImageWidget(
              imageUrl: iconPath,
              height: 28.w,
              width: 28.w,
              boxFit: BoxFit.contain,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.slateText,
            ),
          ),
        ),
      ],
    );
  }
}
