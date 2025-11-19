import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/models/module_status_model.dart';
import 'package:VoiceGive/models/module_sample_model.dart';
import 'package:VoiceGive/services/module_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/branding_config.dart';

class DekhoDemoScreen extends StatefulWidget {
  const DekhoDemoScreen({super.key});

  @override
  State<DekhoDemoScreen> createState() => _DekhoDemoScreenState();
}

class _DekhoDemoScreenState extends State<DekhoDemoScreen> {
  ModuleStatusModel? statusModel;
  ModuleSampleModel? sampleModel;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModuleData();
  }

  Future<void> _loadModuleData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      statusModel = await ModuleService.getModuleStatus('dekho');
      
      if (statusModel == null) {
        setState(() {
          errorMessage = 'Failed to connect to dekho service';
          isLoading = false;
        });
        return;
      }
      
      if (statusModel?.status != 'ok') {
        setState(() {
          errorMessage = 'Service status: ${statusModel?.status}';
          isLoading = false;
        });
        return;
      }

      sampleModel = await ModuleService.getModuleSample('dekho');
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load module data: $e';
        isLoading = false;
      });
    }
  }

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
                  onTap: () => Navigator.pop(context),
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
                  'DEKHO',
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
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.grey84),
            SizedBox(height: 16.h),
            Text(
              'Error',
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.greys87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage!,
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 16.sp,
                color: AppColors.grey84,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(24).r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(color: AppColors.grey16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sampleModel?.comment.isNotEmpty == true) ...[
              Text(
                'API Response:',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreen,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                sampleModel!.comment,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 14.sp,
                  color: AppColors.greys87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
            ],
            if (sampleModel?.sampleItems.isNotEmpty == true) ...[
              Text(
                'Sample Items:',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreen,
                ),
              ),
              SizedBox(height: 12.h),
              ...sampleModel!.sampleItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  '${item.id}: ${item.text}',
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}