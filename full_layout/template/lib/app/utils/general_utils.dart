import 'package:flutter/material.dart';
import 'package:full_layout_base/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

bool get isLargeScreen => 100.h > 1000;
bool get isSmallScreen => 100.h <= 700;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get globalContext => navigatorKey.currentContext!;

AppLocalizations get translate => AppLocalizations.of(globalContext)!;
