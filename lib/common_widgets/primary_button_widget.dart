import 'package:VoiceGive/common_widgets/page_loader.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String title;
  final Widget? prefix;
  final Function? onTap;
  final BoxDecoration? decoration;
  final Color? textColor;
  final double? textFontSize;
  final ValueNotifier<bool>? isLoading;
  final bool? isLightTheme;
  final double? verticalPadding;
  final double? horizontalPadding;
  final FontWeight? fontWeight;

  const PrimaryButtonWidget(
      {super.key,
      required this.title,
      this.prefix,
      this.onTap,
      this.decoration,
      this.textColor,
      this.textFontSize,
      this.isLoading,
      this.isLightTheme,
      this.verticalPadding,
      this.horizontalPadding,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 8.w,
          horizontal: horizontalPadding ?? 16.w,
        ),
        decoration: decoration ??
            BoxDecoration(
              border: Border.all(color: AppColors.grey40),
              borderRadius: BorderRadius.all(Radius.circular(50.0).r),
              color: AppColors.appBarBackground,
            ),
        child: isLoading != null
            ? ValueListenableBuilder(
                valueListenable: isLoading!,
                builder: (BuildContext context, bool loading, Widget? child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: loading ? 0.0 : 1.0,
                        child: _buttonView(),
                      ),
                      if (loading)
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: PageLoader(
                            strokeWidth: 2,
                            isLightTheme: isLightTheme ?? false,
                          ),
                        ),
                    ],
                  );
                },
              )
            : _buttonView(),
      ),
    );
  }

  Widget _buttonView() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: prefix,
            ),
          Text(
            title,
            style: BrandingConfig.instance.getPrimaryTextStyle(
              color: textColor ?? AppColors.grey40,
              fontWeight: fontWeight ?? FontWeight.w700,
              fontSize: textFontSize ?? 12.0.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
