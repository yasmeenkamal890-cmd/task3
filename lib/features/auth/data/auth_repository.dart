/// Authentication boundary for the login feature.
///
/// This project archive does not contain a real Login API client or an
/// interceptor. The demo implementation below preserves the starter app's
/// existing demo behavior. Replace this implementation with the existing API
/// client when that code is available; keep the Cubit and UI unchanged.
abstract class AuthRepository {
  Future<void> login({required String email, required String password});
}

class DemoAuthRepository implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {
    // Simulate a request so loading/success states can be exercised in demo mode.
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
}
