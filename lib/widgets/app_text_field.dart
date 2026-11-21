import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';

/// Label on top + 48 px field with a leading icon (Figma "Input Field").
class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.inputFormatters,
    this.autofillHints,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppText.label),
        const SizedBox(height: AppSpace.xs),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onSubmitted,
          autocorrect: false,
          enableSuggestions: !widget.isPassword,
          style: AppText.body,
          cursorColor: AppColors.textPrimary,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppText.body.copyWith(color: AppColors.textSecondary.withValues(alpha: 0.6)),
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: AppSpace.md, right: AppSpace.sm),
              child: Icon(widget.icon, size: 20, color: AppColors.textPrimary),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20, color: AppColors.textSecondary),
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                  )
                : null,
            errorStyle: AppText.caption.copyWith(color: AppColors.danger),
            enabledBorder: _border(AppColors.borderStrong),
            focusedBorder: _border(AppColors.textPrimary),
            errorBorder: _border(AppColors.danger),
            focusedErrorBorder: _border(AppColors.danger),
          ),
        ),
      ],
    );
  }
}
