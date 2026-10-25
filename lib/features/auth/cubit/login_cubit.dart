import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({AuthRepository? repository})
      : _repository = repository ?? DemoAuthRepository(),
        super(const LoginState());

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) async {
    // Ignore repeated taps while a request is in progress.
    if (state.isLoading) return;

    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      emit(const LoginState(
        status: LoginStatus.error,
        errorMessage: 'Please enter a valid email address.',
      ));
      return;
    }
    if (password.isEmpty) {
      emit(const LoginState(
        status: LoginStatus.error,
        errorMessage: 'Please enter your password.',
      ));
      return;
    }

    emit(const LoginState(status: LoginStatus.loading));
    try {
      await _repository.login(email: normalizedEmail, password: password);
      if (!isClosed) emit(const LoginState(status: LoginStatus.success));
    } catch (_) {
      if (!isClosed) {
        emit(const LoginState(
          status: LoginStatus.error,
          errorMessage: 'Unable to sign in. Please try again.',
        ));
      }
    }
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

  void reset() => emit(const LoginState());
}
