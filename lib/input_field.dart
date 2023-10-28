// ignore_for_file: no_logic_in_create_state, file_names, must_be_immutable

import 'package:flutter/material.dart';

class Inputfield extends StatefulWidget {
  Inputfield({
    super.key,
    this.controller,
    this.hintText = '',
    this.suffixText = '',
    this.prefixText = '',
    this.alignment = TextAlign.left,
    this.keyboardType = TextInputType.name,
    this.enabled = true,
    this.onChanged,
    this.maxLength,
  }) {
    controller ??= TextEditingController();
  }
  TextEditingController? controller = TextEditingController();
  final String hintText, suffixText, prefixText;
  final TextAlign alignment;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLength;
  Function(String)? onChanged;

  @override
  State<Inputfield> createState() => _InputfieldState(
        super.key,
        controller: controller!,
        hinttext: hintText,
        suffixtext: suffixText,
        prefixtext: prefixText,
        alignment: alignment,
        keyboardtype: keyboardType,
        onChanged: onChanged,
        enabled: enabled,
        maxLength: maxLength,
      );
}

class _InputfieldState extends State<Inputfield> {
  _InputfieldState(Key? key,
      {required this.controller,
      required this.hinttext,
      required this.suffixtext,
      required this.prefixtext,
      required this.keyboardtype,
      required this.alignment,
      required this.onChanged,
      required this.enabled,
      this.maxLength});
  final TextEditingController controller;
  final String hinttext, suffixtext, prefixtext;
  final TextAlign alignment;
  final TextInputType keyboardtype;
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
        keyboardType: keyboardtype,
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
          hintText: hinttext,
          suffixText: suffixtext,
          prefixText: prefixtext,
        ),
      ),
    );
  }
}
