import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class FormDropdownField extends StatelessWidget {
  final dynamic value;
  final Widget hint;
  final List<DropdownMenuItem<dynamic>> items;
  final FormFieldValidator<dynamic> validator;
  final FormFieldSetter<dynamic> onSaved;
  final ValueChanged<dynamic> onChanged;

  FormDropdownField({
    this.value,
    this.hint,
    this.items,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
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
      ),
      hint: hint,
      items: items,
      validator: validator,
      onSaved: onSaved,
      
      // dropdown list doesn't show up without this
      onChanged: onChanged,
    );
  }
}