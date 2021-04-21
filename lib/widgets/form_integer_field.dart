import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class FormIntegerField extends StatelessWidget {
  final String initialValue;
  final String hintText;
  final FormFieldSetter<String> onSaved;

  FormIntegerField({this.initialValue, this.hintText, this.onSaved});
  
  @override
  Widget build(BuildContext context) {
    return FormTextField(
      hintText: hintText,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value == null || value.trim() == '') {
          return 'Enter an integer.';
        }

        int parsed;

        try { 
          parsed = int.parse(value);
        } catch(error) {
          return 'Enter a valid integer.';
        }

        if(parsed <= 0) {
          return 'Integer must be greater than zero.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
    );
  }
}