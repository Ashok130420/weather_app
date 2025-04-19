import 'package:flutter/material.dart';
import 'package:weather/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration decoration;
  final TextOverflow overflow;
  final double decorationThickness;

  const CustomText(this.text,
      {super.key,
      this.color = AppColors.black,
      this.fontSize = 12,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.start,
      this.decoration = TextDecoration.none,
      this.decorationThickness = 1,
      this.overflow = TextOverflow.visible});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
          color: color, fontSize: fontSize, fontWeight: fontWeight, decorationThickness: decorationThickness, decoration: decoration),
    );
  }
}
