import 'package:flutter/widgets.dart';

class W extends StatelessWidget {
  final double width;

  const W(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
