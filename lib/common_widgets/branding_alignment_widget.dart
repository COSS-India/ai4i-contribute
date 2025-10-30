import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandingAlignmentWidget extends StatelessWidget {
  final double? fontSize;
  final Color? textColor;
  final bool showSeparators;
  final bool showBhashiniIcon;
  final double iconScale; // relative to font size
  // Nudge BHASHINI (icon + text) vertically to match visual baseline
  // Positive value moves up; expressed as a fraction of font size
  final double bhashiniYOffsetFactor;
  // Nudge BhashaDaan group vertically
  final double bhashaDaanYOffsetFactor;
  // Nudge AgriDaan group vertically
  final double agriDaanYOffsetFactor;

  const BrandingAlignmentWidget({
    super.key,
    this.fontSize,
    this.textColor,
    this.showSeparators = true,
    this.showBhashiniIcon = true,
    this.iconScale = 0.9,
    this.bhashiniYOffsetFactor = 0.10,
    this.bhashaDaanYOffsetFactor = 0.10,
    this.agriDaanYOffsetFactor = 0.10,
  });

  @override
  Widget build(BuildContext context) {
    final double resolvedFontSize = fontSize ?? 12.sp;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // BHASHINI (icon + text) aligned and slightly nudged up
        Transform.translate(
          offset: Offset(0, -resolvedFontSize * bhashiniYOffsetFactor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'AI4I - Contribute',
                style: GoogleFonts.notoSans(
                  fontSize: resolvedFontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ),

        if (showSeparators) ...[
          SizedBox(width: 8.w),
          Container(
            width: 1.w,
            height: resolvedFontSize * 0.8,
            color: Colors.grey[400],
          ),
          SizedBox(width: 8.w),
        ],
      ],
    );
  }
}
