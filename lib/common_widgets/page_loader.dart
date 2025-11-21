import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PageLoader extends StatelessWidget {
  final double top;
  final double bottom;
  final double strokeWidth;
  final bool isLightTheme;

  const PageLoader(
      {super.key,
      this.top = 0,
      this.bottom = 0,
      this.isLightTheme = true,
      this.strokeWidth = 4.0});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: top, bottom: bottom),
        child: Center(
            child: CircularProgressIndicator(
          color: isLightTheme ? AppColors.orange : AppColors.appBarBackground,
          strokeWidth: strokeWidth,
        )));
  }
}
