import 'package:ai4i_contribute/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerSkeleton extends StatefulWidget {
  final double height;
  final double width;
  final double padding;
  final double radius;
  final Widget? child;

  const ContainerSkeleton(
      {super.key,
      this.height = 10,
      this.width = 10,
      this.padding = 0,
      this.radius = 8,
      this.child});

  @override
  ContainerSkeletonState createState() => ContainerSkeletonState();
}

class ContainerSkeletonState extends State<ContainerSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<Color?> animation;
  @override
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    animation = TweenSequence<Color?>([
      TweenSequenceItem<Color?>(
        weight: 1.0,
        tween: ColorTween(
          begin: AppColors.grey04,
          end: AppColors.grey08,
        ),
      ),
      TweenSequenceItem<Color?>(
        weight: 1.0,
        tween: ColorTween(
          begin: AppColors.grey04,
          end: AppColors.grey08,
        ),
      ),
    ]).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _controller!.repeat(reverse: true);
  }

  @override
  dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          color: animation.value,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: widget.child ?? const Center());
  }
}
