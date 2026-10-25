# Task 2 — Login Cubit refactor

## What changed
- Replaced UI-coupled demo login logic with `LoginCubit` and immutable `LoginState`.
- Added explicit `initial`, `loading`, `success`, and `error` states.
- Moved login operation behind `AuthRepository` so the Cubit does not depend on UI or an HTTP client directly.
- Prevented duplicate login submissions while loading and added exception handling.
- Updated the login screen to react to Cubit state and retained the existing navigation and sign-out flow.

## Important limitation of the supplied branch
The uploaded `auth_interceptor` branch contains no real Login API client, HTTP interceptor, or API configuration. The existing login was a demo delay that accepts any valid-looking email and non-empty password. To avoid inventing an endpoint or changing unknown API behavior, `DemoAuthRepository` preserves that demo behavior and marks the integration point. When the real API/interceptor code is available, implement `AuthRepository.login` using that existing client.

## Run and verify
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```
