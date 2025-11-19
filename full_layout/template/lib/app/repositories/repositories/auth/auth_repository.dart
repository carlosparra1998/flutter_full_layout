import 'dart:convert';

import 'package:full_layout_base/app/enums/http_call.dart';
import 'package:full_layout_base/app/repositories/clients/client_response.dart';
import 'package:full_layout_base/app/repositories/clients/http_client/http_client.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/auth_endpoints.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/models/auth_session.dart';

class AuthRepository {
  final HttpClient client;

  AuthRepository(this.client);

  Future<ClientResponse<AuthSession>> login(
    String username,
    String password,
  ) async {
    return await client.call<AuthSession, AuthSession>(
      AuthEndpoints.login,
      method: HttpCall.POST,
      data: jsonEncode({
        'username' : username,
        'password' : password,
      })
    );
  }
}
