import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/bolo_get_started.dart';
import 'package:VoiceGive/screens/suno/suno_get_started.dart';
import 'package:VoiceGive/screens/likho/likho_get_started.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/branding_config.dart';
import 'dekho/dekho_get_started.dart';

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/module_selector_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 24.sp,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    SizedBox(height: 40.h),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Namaste ',
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orange,
                              ),
                            ),
                            Text(
                              '🙏',
                              style: TextStyle(fontSize: 24.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Contributor/Validator',
                          textAlign: TextAlign.center,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Welcome to BhashaDaan',
                          textAlign: TextAlign.center,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'A movement to strengthen India\'s languages. Your contributions help make technology truly multilingual.',
                          textAlign: TextAlign.center,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _buildGridView(),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 188 / 235,
      children: _getModuleData()
          .map((module) => _buildModuleTile(
              title: module['title'],
              icon: module['icon'],
              onTap: module['onTap'],
              assetPath: module['assetPath']))
          .toList(),
    );
  }

  List<Map<String, dynamic>> _getModuleData() {
    final List<Map<String, dynamic>> allModules = [
      if (BrandingConfig.instance.boloEnabled)
        {
          'title': 'Bolo India',
          'icon': Icons.mic,
          'assetPath': 'assets/images/bolo.png',
          'color': AppColors.orange,
          'onTap': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BoloGetStarted()),
              ),
        },
      if (BrandingConfig.instance.sunoEnabled)
        {
          'title': 'Suno India',
          'icon': Icons.headphones,
          'assetPath': 'assets/images/suno.png',
          'color': AppColors.darkGreen,
          'onTap': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SunoGetStarted()),
              ),
        },
      if (BrandingConfig.instance.dekhoEnabled)
        {
          'title': 'Dekho India',
          'icon': Icons.visibility,
          'assetPath': 'assets/images/dekho.png',
          'color': AppColors.grey84,
          'onTap': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DekhoGetStarted()),
              ),
        },
      if (BrandingConfig.instance.likhoEnabled)
        {
          'title': 'Likho India',
          'icon': Icons.edit,
          'assetPath': 'assets/images/likho.png',
          'color': AppColors.lightGreen,
          'onTap': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LikhoGetStarted()),
              ),
        },
    ];
    return allModules;
  }

  Widget _buildModuleTile({
    required String title,
    required String assetPath,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20).r,
        decoration: BoxDecoration(
          color: Color(0xFFEBFFEF),
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 120.w,
              height: 110.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  icon,
                  size: 80.sp,
                  color: AppColors.darkGreen,
                );
              },
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
