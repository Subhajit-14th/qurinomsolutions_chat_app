import 'user_model.dart';

class LoginResponse {
  final bool encrypted;
  final String token;
  final UserModel user;

  LoginResponse({
    required this.encrypted,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LoginResponse(
      encrypted: json['encrypted'] ?? false,
      token: data['token'] ?? '',
      user: UserModel.fromJson(data['user'] ?? {}),
    );
  }
}
