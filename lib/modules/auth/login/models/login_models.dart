import '../../../../core/models/user_model.dart';

class LoginRequest {
  final String phoneNumber;
  final String password;

  const LoginRequest({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "password": password,
  };
}

class LoginResponse {
  final UserModel user;
  final String token;

  const LoginResponse({required this.user, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: (json['token'] ?? '') as String,
    );
  }
}

class LogoutResponse {
  final String message;

  const LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(message: (json['message'] ?? '') as String);
  }
}
