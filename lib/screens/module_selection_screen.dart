import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/bolo_get_started.dart';
import 'package:VoiceGive/screens/demo_screen.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:VoiceGive/screens/unicode_validation_demo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/branding_config.dart';

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    final branding = BrandingConfig.instance;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16).r,
            decoration: BoxDecoration(color: AppColors.bannerColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
                SizedBox(width: 24.w),
                branding.bannerImage.isNotEmpty
                    ? ImageWidget(
                        imageUrl: branding.bannerImage,
                        height: 40.w,
                        width: 40.w,
                      )
                    : SizedBox(width: 40.w, height: 40.w),
                SizedBox(width: 8.w),
                Text(
                  "Choose Module",
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24).r,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildViewToggle(),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: isGridView ? _buildGridView() : _buildListView(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: AppColors.grey16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isGridView = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isGridView ? AppColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(6).r,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view,
                    size: 20.sp,
                    color: isGridView ? Colors.white : AppColors.grey84,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Grid",
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 14.sp,
                      color: isGridView ? Colors.white : AppColors.grey84,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isGridView = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: !isGridView ? AppColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(6).r,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.list,
                    size: 20.sp,
                    color: !isGridView ? Colors.white : AppColors.grey84,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "List",
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 14.sp,
                      color: !isGridView ? Colors.white : AppColors.grey84,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      children: _getModuleData().map((module) => _buildModuleTile(
        context,
        title: module['title'],
        subtitle: module['subtitle'],
        icon: module['icon'],
        color: module['color'],
        onTap: module['onTap'],
        isGridView: true,
      )).toList(),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: _getModuleData().length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final module = _getModuleData()[index];
        return _buildModuleTile(
          context,
          title: module['title'],
          subtitle: module['subtitle'],
          icon: module['icon'],
          color: module['color'],
          onTap: module['onTap'],
          isGridView: false,
        );
      },
    );
  }

  List<Map<String, dynamic>> _getModuleData() {
    return [
      {
        'title': 'Bolo',
        'subtitle': 'Voice Recording',
        'icon': Icons.mic,
        'color': AppColors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BoloGetStarted()),
        ),
      },
      {
        'title': 'Suno',
        'subtitle': 'Audio Listening',
        'icon': Icons.headphones,
        'color': AppColors.darkGreen,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DemoScreen(module: 'suno')),
        ),
      },
      {
        'title': 'Likho',
        'subtitle': 'Text Writing',
        'icon': Icons.edit,
        'color': AppColors.lightGreen,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DemoScreen(module: 'likho')),
        ),
      },
      {
        'title': 'Dekho',
        'subtitle': 'Visual Content',
        'icon': Icons.visibility,
        'color': AppColors.grey84,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DemoScreen(module: 'dekho')),
        ),
      },
      {
        'title': 'Unicode Demo',
        'subtitle': 'Text Validation',
        'icon': Icons.text_fields,
        'color': Colors.purple,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UnicodeValidationDemoScreen()),
        ),
      },
    ];
  }

  Widget _buildModuleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isGridView,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16).r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: isGridView ? _buildGridTileContent(icon, color, title, subtitle) : _buildListTileContent(icon, color, title, subtitle),
      ),
    );
  }

  Widget _buildGridTileContent(IconData icon, Color color, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 32.sp,
            color: color,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          title,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.greys87,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 12.sp,
            color: AppColors.grey84,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildListTileContent(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: color,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greys87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey84,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppColors.grey84,
        ),
      ],
    );
  }
}
