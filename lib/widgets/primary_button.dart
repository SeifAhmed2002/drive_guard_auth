import 'package:material_ui/material_ui.dart';

import '../core/theme.dart';

/// Big white button (64 px tall, radius 16) from the design system.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.onAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl, vertical: AppSpace.xs),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.onAccent),
              )
            : Text(label, style: AppText.labelLarge.copyWith(color: AppColors.onAccent)),
      ),
    );
  }
}
