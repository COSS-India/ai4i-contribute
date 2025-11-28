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
  final double _minZoom = 0.8;
  final double _maxZoom = 3.0;
  final double _zoomStep = 0.2;
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Reset zoom level to 100% on widget initialization
    _zoomLevel = 1.0;
    _transformationController.value = Matrix4.identity();
  }

  @override
  void didUpdateWidget(ImageViewerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset zoom when image URL changes
    if (oldWidget.imageUrl != widget.imageUrl) {
      _zoomLevel = 1.0;
      _transformationController.value = Matrix4.identity();
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + _zoomStep).clamp(_minZoom, _maxZoom);
      _applyZoom();
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - _zoomStep).clamp(_minZoom, _maxZoom);
      _applyZoom();
    });
  }

  void _applyZoom() {
    final currentMatrix = _transformationController.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final scaleRatio = _zoomLevel / currentScale;

    final newMatrix = currentMatrix.clone()..scale(scaleRatio);

    _transformationController.value = newMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)).r,
        color: AppColors.lightGreen1,
        border: Border.all(color: AppColors.lightGreen5, width: 1),
      ),
      child: Row(
        children: [
          // Image container
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8).r,
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8).r,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: _minZoom,
                  maxScale: _maxZoom,
                  panEnabled: true,
                  scaleEnabled: true,
                  boundaryMargin: EdgeInsets.zero,
                  constrained: true,
                  onInteractionUpdate: (details) {
                    final currentScale = _transformationController.value.getMaxScaleOnAxis();
                    setState(() {
                      _zoomLevel = currentScale.clamp(_minZoom, _maxZoom);
                    });
                  },
                  child: Container(
                    key: _imageKey,
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
                                size: 24.sp,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Image not available',
                                style:
                                    BrandingConfig.instance.getPrimaryTextStyle(
                                  fontSize: 10.sp,
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
          // Zoom controls
          Container(
            width: 25.w,
            margin: EdgeInsets.only(right: 8.w),
            child: Container(
              width: 25.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20).r,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Zoom in button
                  GestureDetector(
                    onTap: _zoomIn,
                    child: Container(
                      width: 25.w,
                      height: 30.w,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  // Zoom percentage
                  Container(
                    width: 25.w,
                    height: 25.w,
                    child: Center(
                      child: Text(
                        '${(_zoomLevel * 100).round()}%',
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Zoom out button
                  GestureDetector(
                    onTap: _zoomOut,
                    child: Container(
                      width: 25.w,
                      height: 30.w,
                      child: Icon(
                        Icons.remove,
                        color: Colors.black,
                        size: 20.sp,
                      ),
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
}
