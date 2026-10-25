import 'package:flutter/foundation.dart';

enum LoginStatus { initial, loading, success, error }

@immutable
class LoginState {
  const LoginState({this.status = LoginStatus.initial, this.errorMessage});

  final LoginStatus status;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;
}
