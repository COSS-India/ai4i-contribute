import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';

class ImageViewerWidget extends StatefulWidget {
  final String imageUrl;

  const ImageViewerWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ImageViewerWidget> createState() => _ImageViewerWidgetState();
}

class _ImageViewerWidgetState extends State<ImageViewerWidget> {
  double _zoomLevel = 1.0;
  final double _minZoom = 0.5;
  final double _maxZoom = 3.0;
  final double _zoomStep = 0.2;

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + _zoomStep).clamp(_minZoom, _maxZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - _zoomStep).clamp(_minZoom, _maxZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12).r,
        border: Border.all(color: AppColors.darkGreen, width: 2),
      ),
      child: Row(
        children: [
          // Image container
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8).r,
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8).r,
                child: InteractiveViewer(
                  minScale: _minZoom,
                  maxScale: _maxZoom,
                  child: Transform.scale(
                    scale: _zoomLevel,
                    child: Center(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 48.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Image not available',
                                  style: BrandingConfig.instance.getPrimaryTextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600]!,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[100],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.darkGreen,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Zoom controls
          Container(
            width: 60.w,
            margin: EdgeInsets.only(right: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Zoom in button
                GestureDetector(
                  onTap: _zoomIn,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20).r,
                        topRight: Radius.circular(20).r,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                // Zoom percentage
                Container(
                  width: 40.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen4,
                    border: Border.symmetric(
                      horizontal: BorderSide(color: AppColors.darkGreen, width: 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${(_zoomLevel * 100).round()}%',
                      style: BrandingConfig.instance.getPrimaryTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                // Zoom out button
                GestureDetector(
                  onTap: _zoomOut,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20).r,
                        bottomRight: Radius.circular(20).r,
                      ),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}