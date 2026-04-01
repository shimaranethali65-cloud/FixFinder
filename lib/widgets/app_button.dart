import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppButtonVariant { filled, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == AppButtonVariant.filled;

    return SizedBox(
      width: width,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isFilled ? AppColors.primaryBlue : AppColors.white,
          foregroundColor: isFilled ? AppColors.white : AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isFilled
                ? BorderSide.none
                : const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
