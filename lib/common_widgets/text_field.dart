import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField(
      {Key? key,
      required this.label,
      this.hintText,
      this.helperText,
      this.initialInput,
      this.prefixIcon,
      this.inputType = TextInputType.text,
      this.maxLines,
      this.controller})
      : super(key: key);

  final String label;
  final String? hintText;
  final String? helperText;
  final String? initialInput;
  final IconData? prefixIcon;
  final TextInputType inputType;
  final int? maxLines;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold))),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: inputType,
          initialValue: initialInput,
          decoration: InputDecoration(
            isDense: true,
            helperText: helperText,
            hintText: hintText,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: prefixIcon == null ? 16 : 0),
          ),
        ),
      ],
    );
  }
}
