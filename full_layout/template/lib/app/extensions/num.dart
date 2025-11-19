import 'package:full_layout_base/app/utils/general_utils.dart';

extension NumExtension on num {
  double responsive({num? smallSize, num? largeSize}) =>
      (isLargeScreen
              ? largeSize ?? this
              : isSmallScreen
              ? smallSize ?? this
              : this)
          .toDouble();
}
