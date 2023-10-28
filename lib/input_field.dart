// ignore_for_file: no_logic_in_create_state, file_names, must_be_immutable

import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {
  Inputfield({
    super.key,
    controller,
    this.hintText = '',
    this.suffixText = '',
    this.prefixText = '',
    this.alignment = TextAlign.left,
    this.keyboardType = TextInputType.name,
    this.enabled = true,
    this.onChanged,
    this.maxLength,
  }) {
    this.controller = controller ?? TextEditingController();
  }
  late TextEditingController controller;
  final String hintText, suffixText, prefixText;
  final TextAlign alignment;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLength;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        textAlign: alignment,
        enabled: enabled,
        maxLength: maxLength,
        style: TextStyle(
            color:
                (MediaQuery.of(context).platformBrightness == Brightness.light)
                    ? Colors.black
                    : Colors.white),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 3),
          ),
          hintText: hintText,
          suffixText: suffixText,
          prefixText: prefixText,
        ),
      ),
    );
  }
}
