import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Widget? icon;
  final Color? color;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.color = AppColors.white,
    this.bgColor = AppColors.primary,
    this.borderColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 30),
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              CustomText(
                title,
                fontSize: fontSize ?? 16.0,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: color ?? AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
