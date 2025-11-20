import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';

extension NumExtension on num {
  double responsive({num? smallSize, num? largeSize}) => (isLargeScreen
          ? largeSize ?? this
          : isSmallScreen
              ? smallSize ?? this
              : this)
      .toDouble();
}
