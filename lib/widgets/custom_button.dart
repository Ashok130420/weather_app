import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;

  CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color = AppColors.white,
    this.bgColor = AppColors.primary,
    this.borderColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
        child: TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 30),
            side: BorderSide.none,
          ),
          child: CustomText(
            title,
            fontSize: fontSize ?? 16.0,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
