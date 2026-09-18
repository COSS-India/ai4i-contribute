import 'package:ai4i_contribute/common_widgets/container_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit? boxFit;
  final Color? imageColor;

  const ImageWidget(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.radius,
      this.boxFit,
      this.imageColor});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = widget.imageUrl.startsWith('http://') ||
        widget.imageUrl.startsWith('https://');

    bool isSvg = widget.imageUrl.toLowerCase().endsWith('.svg');

    bool isAssetImage = !isNetworkImage && !widget.imageUrl.startsWith('http');

    return isNetworkImage
        ? isSvg
            ? SizedBox(
                height: widget.height,
                width: widget.width,
                child: SvgPicture.network(
                  fit: widget.boxFit ?? BoxFit.fill,
                  widget.imageUrl,
                  height: widget.height,
                  width: widget.width,
                  colorFilter: widget.imageColor != null
                      ? ColorFilter.mode(
                          widget.imageColor!,
                          BlendMode.srcIn,
                        )
                      : null,
                  placeholderBuilder: (context) => ContainerSkeleton(
                    height: widget.height ?? 16,
                    width: widget.width ?? 16,
                    radius: widget.radius ?? 4,
                  ),
                ),
              )
            : SizedBox(
                height: widget.height,
                width: widget.width,
                child: CachedNetworkImage(
                  fit: widget.boxFit ?? BoxFit.fill,
                  height: widget.height,
                  width: widget.width,
                  imageUrl: widget.imageUrl,
                  color: widget.imageColor,
                  placeholder: (context, url) => ContainerSkeleton(
                    height: widget.height ?? 16,
                    width: widget.width ?? 16,
                    radius: widget.radius ?? 4,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: widget.height,
                    width: widget.width,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.grey[600]),
                  ),
                ),
              )
        : isAssetImage
            ? (isSvg
                ? SizedBox(
                    height: widget.height,
                    width: widget.width,
                    child: SvgPicture.asset(
                      fit: widget.boxFit ?? BoxFit.fill,
                      widget.imageUrl,
                      height: widget.height,
                      width: widget.width,
                      colorFilter: widget.imageColor != null
                          ? ColorFilter.mode(
                              widget.imageColor!,
                              BlendMode.srcIn,
                            )
                          : null,
                      placeholderBuilder: (context) => ContainerSkeleton(
                        height: widget.height ?? 16,
                        width: widget.width ?? 16,
                        radius: widget.radius ?? 4,
                      ),
                    ),
                  )
                : SizedBox(
                    height: widget.height,
                    width: widget.width,
                    child: Image.asset(
                      fit: widget.boxFit ?? BoxFit.fill,
                      widget.imageUrl,
                      height: widget.height,
                      width: widget.width,
                      color: widget.imageColor,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: widget.height,
                        width: widget.width,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.grey[600]),
                      ),
                    ),
                  ))
            : SizedBox.shrink();
  }
}
