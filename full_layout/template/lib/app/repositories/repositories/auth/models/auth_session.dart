class AuthSession {
  late String accessToken;
  late String refreshToken;

  AuthSession({required this.accessToken, required this.refreshToken});

  AuthSession.fromJson(Map<String, dynamic> json){
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}
