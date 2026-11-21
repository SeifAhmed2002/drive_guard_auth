class Validators {
  static String? fullName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Please enter your full name';
    if (s.length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Please enter your email';
    final ok = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(s);
    return ok ? null : 'Enter a valid email address';
  }

  /// Accepts +20 10 2345 6789, 01023456789, etc.
  static String? phone(String? v) {
    final s = (v ?? '').replaceAll(RegExp(r'[\s\-()]'), '');
    if (s.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(s)) return 'Enter a valid phone number';
    return null;
  }

  static String? loginPassword(String? v) {
    if ((v ?? '').isEmpty) return 'Please enter your password';
    return null;
  }

  static String? newPassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return 'Please create a password';
    if (s.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(s) || !RegExp(r'\d').hasMatch(s)) {
      return 'Use letters and numbers';
    }
    return null;
  }
}
