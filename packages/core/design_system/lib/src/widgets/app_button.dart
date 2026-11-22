import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    super.key,
  });

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final leading = isLoading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : (icon != null ? Icon(icon, size: 20) : null);

    return switch (variant) {
      AppButtonVariant.primary =>
        leading == null
            ? FilledButton(onPressed: onTap, child: Text(label))
            : FilledButton.icon(
                onPressed: onTap,
                icon: leading,
                label: Text(label),
              ),
      AppButtonVariant.secondary =>
        leading == null
            ? OutlinedButton(onPressed: onTap, child: Text(label))
            : OutlinedButton.icon(
                onPressed: onTap,
                icon: leading,
                label: Text(label),
              ),
    };
  }
}
