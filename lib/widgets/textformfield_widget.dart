import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controllername,
    this.obscureText = false,
    this.prefixIconData,
    this.suffixIconData,
    this.focusNode,
    this.onChanged,
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.textInputType,
    this.maxLength,
  });

  final String hintText;
  final TextEditingController controllername;
  final bool obscureText;
  final IconData? prefixIconData;
  final IconButton? suffixIconData;
  final FocusNode? focusNode;
  final Function? onChanged;
  final FormFieldValidator? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: textInputType,
      validator: validator,
      autovalidateMode: autovalidateMode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: controllername,
      decoration: InputDecoration(
        // Prefix Icon (if provided)
        prefixIcon: prefixIconData != null ? Icon(prefixIconData) : null,

        // Suffix Icon (if provided)
        suffixIcon: suffixIconData,

        // Border styling
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

        // Label text (Hint text for the input)
        labelText: hintText,
      ),
    );
  }
}
