import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../services/auth_service.dart';
import '../widgets/primary_button.dart';
import 'permissions_screen.dart';

/// NOTE: the Figma file has no verification screen, so this one follows the
/// same design system (6-digit code). Demo code with the mock service: 123456.
class VerificationScreen extends StatefulWidget {
  final String phone;
  const VerificationScreen({super.key, required this.phone});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _length = 6;
  static const _resendSeconds = 30;

  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _left = _resendSeconds;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _left = _left - 1 < 0 ? 0 : _left - 1);
    });
  }

  Future<void> _verify() async {
    if (_code.text.length != _length) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await authService.verifyCode(phone: widget.phone, code: _code.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PermissionsScreen()),
        (_) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
      _code.clear();
      _focus.requestFocus();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    await authService.resendCode(phone: widget.phone);
    if (!mounted) return;
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A new code was sent.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xs, AppSpace.lg, AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verify your phone', style: AppText.h1),
                    const SizedBox(height: AppSpace.xs),
                    Text('Enter the 6-digit code we sent to ${widget.phone}.', style: AppText.bodySecondary),
                    const SizedBox(height: AppSpace.xl),
                    _CodeBoxes(controller: _code, focusNode: _focus, hasError: _error != null, onChanged: (v) {
                      if (_error != null) setState(() => _error = null);
                      setState(() {});
                      if (v.length == _length) _verify();
                    }),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpace.sm),
                        child: Text(_error!, style: AppText.caption.copyWith(color: AppColors.danger)),
                      ),
                    const SizedBox(height: AppSpace.lg),
                    Row(
                      children: [
                        Text("Didn't get a code?", style: AppText.bodySecondary),
                        const SizedBox(width: AppSpace.xxs),
                        if (_left > 0)
                          Text('Resend in ${_left}s', style: AppText.body.copyWith(color: AppColors.textSecondary))
                        else
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _resend,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('Resend', style: AppText.labelLarge),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.lg),
                    PrimaryButton(label: 'Verify', loading: _loading, onPressed: _verify),
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

/// 6 boxes driven by one invisible text field on top (paste / autofill friendly).
class _CodeBoxes extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  const _CodeBoxes({required this.controller, required this.focusNode, required this.hasError, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final text = controller.text;
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          Row(
            children: List.generate(6, (i) {
              final filled = i < text.length;
              final active = focusNode.hasFocus && i == text.length.clamp(0, 5);
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == 5 ? 0 : AppSpace.xs),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: hasError
                          ? AppColors.danger
                          : (active ? AppColors.textPrimary : AppColors.borderStrong),
                    ),
                  ),
                  child: Text(filled ? text[i] : '', style: AppText.h1.copyWith(fontSize: 24, height: 32 / 24)),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                showCursor: false,
                enableInteractiveSelection: false,
                onChanged: onChanged,
                decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
