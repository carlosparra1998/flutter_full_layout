import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:{{PROJECT_NAME}}/app/app.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/http_client/http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final HttpClient httpClient = HttpClient(
    Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        sendTimeout: Duration(milliseconds: 5000),
        connectTimeout: Duration(milliseconds: 5000),
        receiveTimeout: Duration(milliseconds: 5000),
      ),
    ),
  );

  runApp(BaseApp(httpClient));
}
