import 'package:material_ui/material_ui.dart';

import '../core/theme.dart';
import '../core/validators.dart';
import '../services/auth_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/brand_logo.dart';
import '../widgets/primary_button.dart';
import 'home_placeholder.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await authService.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePlaceholderScreen()),
        (_) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset is not part of this task yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xxl, AppSpace.lg, AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandLogo(),
                    const SizedBox(height: AppSpace.xxl),
                    Text('Welcome back', style: AppText.h1),
                    const SizedBox(height: AppSpace.xs),
                    Text('Sign in to start monitoring your trips.', style: AppText.bodySecondary),
                    const SizedBox(height: AppSpace.xl),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                            label: 'Password',
                            controller: _password,
                            icon: Icons.lock_outline,
                            hint: '••••••••',
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            validator: Validators.loginPassword,
                            onSubmitted: (_) => _submit(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                          minimumSize: const Size(48, 48),
                        ),
                        child: Text('Forgot password?', style: AppText.label),
                      ),
                    ),
                    const SizedBox(height: AppSpace.xs),
                    PrimaryButton(label: 'Sign in', loading: _loading, onPressed: _submit),
                    const Spacer(),
                    const SizedBox(height: AppSpace.lg),
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpace.xxs,
                        children: [
                          Text("Don't have an account?", style: AppText.bodySecondary),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('Create one', style: AppText.labelLarge),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        'By signing in you agree to our Terms and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: AppText.caption,
                      ),
                    ),
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
