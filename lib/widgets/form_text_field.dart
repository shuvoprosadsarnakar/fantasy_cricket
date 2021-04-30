import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final bool obscureText;

  const FormTextField({
    this.hintText,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.name,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        errorMaxLines: 5, // to avoid validation message ellipsis
        fillColor: ColorPallate.mercury,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 6,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: TextStyle(fontSize: 16),
        hintText: hintText,
      ),
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
    );
  }
}
