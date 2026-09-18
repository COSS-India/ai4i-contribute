import 'package:ai4i_contribute/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordingAnimation extends StatefulWidget {
  final bool isloading;
  const RecordingAnimation({super.key, this.isloading = false});

  @override
  State<RecordingAnimation> createState() => _RecordingAnimationState();
}

class _RecordingAnimationState extends State<RecordingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBar(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = (index * 0.15 + _controller.value) % 1.0;
          double heightFactor = 0.5 + 0.5 * (1 - (2 * (value - 0.5)).abs());

          return Container(
            width: 2.5.w,
            height: 30.w * heightFactor,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.circular(2.w),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.isloading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [...List.generate(8, _buildBar)],
              )
            : SizedBox(),
      ],
    );
  }
}
