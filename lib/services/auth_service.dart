class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

/// Replace [MockAuthService] with your real backend implementation
/// (REST / Firebase) - the screens only talk to this interface.
abstract class AuthService {
  Future<void> login({required String email, required String password});

  /// Creates the account and sends a verification code to [phone].
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? inviteCode,
  });

  Future<void> verifyCode({required String phone, required String code});
  Future<void> resendCode({required String phone});
  Future<void> signOut();
}

class MockAuthService implements AuthService {
  /// The code the mock accepts.
  static const demoCode = '123456';

  @override
  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (password.length < 6) throw AuthException('Incorrect email or password.');
  }

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? inviteCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  @override
  Future<void> verifyCode({required String phone, required String code}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (code != demoCode) throw AuthException('That code is not correct. Try again.');
  }

  @override
  Future<void> resendCode({required String phone}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> signOut() async {}
}

/// Simple app-wide access point (swap for Provider / get_it if you prefer).
final AuthService authService = MockAuthService();
