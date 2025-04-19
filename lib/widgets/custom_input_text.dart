import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FormFieldValidator<String>? validator;
  final bool? enable;
  final ValueChanged<String>? onChanged;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? text;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.floatingLabelBehavior,
    this.validator,
    this.enable,
    this.onChanged,
    this.textCapitalization,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.text,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: AppColors.black),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 1,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        enabled: widget.enable ?? true,
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.all(12),
        labelStyle: const TextStyle(fontSize: 14, color: AppColors.black),
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColors.black),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.red),
        ),
        floatingLabelBehavior: widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
          onTap: widget.onSuffixIconPressed,
          child: widget.suffixIcon,
        )
            : null,
      ),
    );
  }
}
