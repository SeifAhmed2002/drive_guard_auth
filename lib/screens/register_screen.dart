import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../core/validators.dart';
import '../services/auth_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _invite = TextEditingController();
  bool _agreed = false;
  bool _showConsentError = false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password, _invite]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    setState(() => _showConsentError = !_agreed);
    if (!valid || !_agreed) return;

    setState(() => _loading = true);
    try {
      final phone = _phone.text.replaceAll(RegExp(r'[\s\-()]'), '');
      await authService.register(
        fullName: _name.text.trim(),
        email: _email.text.trim(),
        phone: phone,
        password: _password.text,
        inviteCode: _invite.text.trim().isEmpty ? null : _invite.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => VerificationScreen(phone: phone)),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar: 48x48 back button
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: AppSpace.md),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.chevron_left, size: 28, color: AppColors.textPrimary),
                    tooltip: 'Back',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xs, AppSpace.lg, AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create account', style: AppText.h1),
                    const SizedBox(height: AppSpace.xs),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpace.xxs,
                      children: [
                        Text('Already have an account?', style: AppText.bodySecondary),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text('Sign in', style: AppText.labelLarge),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.md),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Full name',
                            controller: _name,
                            icon: Icons.person_outline,
                            hint: 'Omar Khaled',
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            validator: Validators.fullName,
                          ),
                          const SizedBox(height: AppSpace.md),
                          AppTextField(
                            label: 'Email',
                            controller: _email,
                            icon: Icons.mail_outline,
                            hint: 'you@company.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            validator: Validators.email,
                          ),
                          const SizedBox(height: AppSpace.md),
                          AppTextField(
                            label: 'Phone',
                            controller: _phone,
                            icon: Icons.smartphone_outlined,
                            hint: '+20 10 2345 6789',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]'))],
                            validator: Validators.phone,
                          ),
                          const SizedBox(height: AppSpace.md),
                          AppTextField(
                            label: 'Password',
                            controller: _password,
                            icon: Icons.lock_outline,
                            hint: 'At least 8 characters',
                            isPassword: true,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: Validators.newPassword,
                          ),
                          const SizedBox(height: AppSpace.md),
                          AppTextField(
                            label: 'Company invite code (optional)',
                            controller: _invite,
                            icon: Icons.group_outlined,
                            hint: 'NILE-4821',
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpace.md),
                    _ConsentRow(
                      value: _agreed,
                      showError: _showConsentError && !_agreed,
                      onChanged: (v) => setState(() {
                        _agreed = v;
                        if (v) _showConsentError = false;
                      }),
                    ),
                    const SizedBox(height: AppSpace.md),
                    PrimaryButton(label: 'Create account', loading: _loading, onPressed: _submit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  final bool value;
  final bool showError;
  final ValueChanged<bool> onChanged;
  const _ConsentRow({required this.value, required this.showError, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: value ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: value ? AppColors.accent : (showError ? AppColors.danger : AppColors.borderStrong),
                      width: 1.5,
                    ),
                  ),
                  child: value ? const Icon(Icons.check, size: 16, color: AppColors.onAccent) : null,
                ),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: Text(
                    'I agree to the Terms and Privacy Policy. Only trip summaries are shared, never video.',
                    style: AppText.bodySmall,
                  ),
                ),
              ],
            ),
            if (showError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 36),
                child: Text('Please accept to continue', style: AppText.caption.copyWith(color: AppColors.danger)),
              ),
          ],
        ),
      ),
    );
  }
}
