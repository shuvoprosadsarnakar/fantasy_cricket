import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class FormIntegerField extends StatelessWidget {
  final String initialValue;
  final String hintText;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<dynamic> onChanged;

  FormIntegerField({
    this.initialValue,
    this.hintText,
    this.onSaved,
    this.onChanged,
  });
  
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

        try { 
          int.parse(value);
          return null;
        } catch(error) {
          return 'Enter a valid integer.';
        }
      },
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
