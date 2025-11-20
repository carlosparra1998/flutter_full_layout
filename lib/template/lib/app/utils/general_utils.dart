import 'package:flutter/material.dart';
import 'package:{{PROJECT_NAME}}/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

bool get isLargeScreen => 100.h > 1000;
bool get isSmallScreen => 100.h <= 700;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get globalContext => navigatorKey.currentContext!;

AppLocalizations get translate => AppLocalizations.of(globalContext)!;

Future<String?> getString(String code) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(code);
}

Future<void> setString(String code, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(code, value);
}

void pop(BuildContext context) => Navigator.pop(context);

void showSnackBar(String message) {
  ScaffoldMessenger.of(
    globalContext,
  ).showSnackBar(SnackBar(content: Text(message)));
}

Future<dynamic> showAppDialog(
  BuildContext context,
  Widget child, {
  bool barrierDismissible = true,
}) async {
  final value = await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) =>
        WillPopScope(onWillPop: () async => barrierDismissible, child: child),
  );
  return value;
}
