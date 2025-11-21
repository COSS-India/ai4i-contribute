import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'image_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 58.h,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0).r,
            child: ImageWidget(
              imageUrl: "assets/images/bhashini_logo.svg",
              height: 36.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10).r,
            width: 1,
            height: 40,
            color: AppColors.grey24,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Bhasha',
                  style: GoogleFonts.notoSans(
                    color: AppColors.darkBlue,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Daan',
                  style: GoogleFonts.notoSans(
                    color: AppColors.saffron,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [const Color(0xff157D52), const Color(0xff26E395)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              'AgriDaan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
