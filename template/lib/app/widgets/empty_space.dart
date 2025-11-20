import 'package:flutter/material.dart';

class EmptySpace extends StatelessWidget {
  final double? size;
  const EmptySpace({this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size ?? 20, height: size ?? 20);
  }
}
