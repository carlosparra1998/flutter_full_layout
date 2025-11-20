import 'dart:convert';

import 'package:{{PROJECT_NAME}}/app/enums/http_call.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/client_response.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/http_client/http_client.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/auth_endpoints.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/models/auth_session.dart';

class AuthRepository {
  final HttpClient client;

  AuthRepository(this.client);

  Future<ClientResponse<AuthSession>> login(
    String email,
    String password,
  ) async {
    return await client.call<AuthSession, AuthSession>(
      AuthEndpoints.login,
      method: HttpCall.POST,
      tokenRequired: false,
      data: jsonEncode({'email': email, 'password': password}),
    );
  }
}
