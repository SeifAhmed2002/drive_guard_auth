# Drive Guard AI - Task 4 (Flutter)
Onboarding + Login + Register + Verification, built from the Figma file.

## Run
1. `flutter create .`   (inside this folder - generates android/ios folders; keep lib/ and pubspec.yaml)
2. `flutter pub get`
3. `flutter run`

Mock backend: any password >= 6 chars logs in; the verification code is `123456`.
Connect your real API by implementing `AuthService` in `lib/services/auth_service.dart`.
