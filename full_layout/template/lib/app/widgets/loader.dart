import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_layout_base/app/style/app_colors.dart';
import 'package:full_layout_base/app/utils/general_utils.dart';

void showLoader(BuildContext context) {
  showAppDialog(context, const ArcLoader(), barrierDismissible: false);
}

class ArcLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const ArcLoader({this.size = 100, this.strokeWidth = 10, super.key});

  @override
  State<ArcLoader> createState() => _ArcLoaderState();
}

class _ArcLoaderState extends State<ArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 6000),
    );
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CustomCircle(
              AppColors.green,
              1.1 * _animation.value,
              widget.size,
              widget.size,
              widget.strokeWidth,
            ),
          ),
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CustomCircle(
              AppColors.blue,
              1.5 * _animation.value,
              widget.size,
              widget.size,
              widget.strokeWidth,
            ),
          ),
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CustomCircle(
              AppColors.pink,
              2.0 * _animation.value,
              widget.size,
              widget.size,
              widget.strokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCircle extends CustomPainter {
  double right;
  double bottom;
  Color color;
  double rad;
  double strokeWidth;

  CustomCircle(this.color, this.rad, this.right, this.bottom, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      Rect.fromLTRB(0, 0, right, bottom),
      pi * rad,
      pi / 3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
