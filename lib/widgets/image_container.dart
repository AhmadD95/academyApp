import 'package:flutter/material.dart';

class imageContainer extends StatelessWidget {
  const imageContainer(
      {Key? key,
      this.height = 125,
      this.borderRadius = 20,
      required this.width,
      required this.imageUrl,
      this.padding,
      this.margin,
      this.child,
      I})
      : super(key: key);

  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }
}
