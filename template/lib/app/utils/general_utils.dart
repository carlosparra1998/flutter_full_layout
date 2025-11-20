import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:{{PROJECT_NAME}}/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

bool get isLargeScreen => 100.h > 1000;
bool get isSmallScreen => 100.h <= 700;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get globalContext => navigatorKey.currentContext!;

AppLocalizations get translate => AppLocalizations.of(globalContext)!;

Future<String?> getStringSharedPreferences(String code) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(code);
}

Future<void> setStringSharedPreferences(String code, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(code, value);
}

DateTime? whenTokenExpires(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );

    final exp = payload['exp'];

    if (exp == null || exp is! int) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  } catch (_) {
    return null;
  }
}

bool isTokenExpired(String token) {
  DateTime? expDate = whenTokenExpires(token);
  if (expDate == null) {
    return true;
  }
  return expDate.isBefore(DateTime.now());
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
