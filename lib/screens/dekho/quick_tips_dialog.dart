import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/branding_config.dart';
import '../../constants/app_colors.dart';

class QuickTipsDialog extends StatelessWidget {
  final String? microphonePath;
  final String? speakerPath;
  final String? noisePath;
  final String? visibilityPath;
  final String? editPath;

  const QuickTipsDialog({
    Key? key,
    this.microphonePath,
    this.speakerPath,
    this.noisePath,
    this.visibilityPath,
    this.editPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  'Quick Tips',
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greys87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Tips in 2 rows
            Column(
              children: [
                // First row - 3 items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTipItem(
                      microphonePath ?? 'assets/icons/mic_icon.png',
                      'Test Your\nMicrophone',
                    ),
                    _buildTipItem(
                      speakerPath ?? 'assets/icons/support_icon.png',
                      'Test Your\nSpeaker',
                    ),
                    _buildTipItem(
                      noisePath ?? 'assets/icons/sound_off_icon.png',
                      'Ensure no\nbackground\nnoise',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Second row - 2 items
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
                    _buildTipItem(
                      visibilityPath ?? 'assets/icons/record_icon.png',
                      'Read once\nbefore\nrecording it',
                    ),
                    const SizedBox(width: 40),
                    _buildTipItem(
                      editPath ?? 'assets/icons/play_icon.png',
                      'Tap Record to\nstart',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String imagePath, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFE9FAF3),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF23D088),
              width: 1,
            ),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 80,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: BrandingConfig.instance.getPrimaryTextStyle(
              fontSize: 10.sp,
              color: AppColors.greys87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
