// lib/widgets/custom_drawer.dart
import 'package:ai4i_contribute/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            drawerHeaders(),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
            menuItem(
                title: "Dashboard", icon: Icons.dashboard_customize_outlined),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
            menuItem(title: "Settings", icon: Icons.settings_outlined),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
            menuItem(title: "Share Application", icon: Icons.share),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
            menuItem(title: "Rate Us", icon: Icons.star),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
            menuItem(title: "Sign Out", icon: Icons.logout),
            Divider(
              color: AppColors.grey08,
              thickness: 1,
              height: 32.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerHeaders() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.darkBlue,
          child: Icon(Icons.person, size: 24.sp, color: Colors.white),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Shankar",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text("View Profile",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  Widget menuItem({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0).r,
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: AppColors.darkBlue),
          SizedBox(width: 16.w),
          Text(title,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
