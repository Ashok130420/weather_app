import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  final double height;
  const Height({super.key, required this.height});
  factory Height.make(double height) {
    return Height(height: height);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class Width extends StatelessWidget {
  final double width;
  const Width({super.key, required this.width});
  factory Width.make(double width) => Width(width: width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
