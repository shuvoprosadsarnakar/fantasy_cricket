import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {

  final Key fieldKey;
  final int maxLength;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  const TextFieldWidget({Key key, this.fieldKey, this.maxLength, this.hintText, this.labelText, this.helperText, this.onSaved, this.validator, this.onFieldSubmitted}) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "",
      cursorColor: Colors.black38,
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
        hintStyle: TextStyle(fontSize: 16),
        hintText: widget.hintText,
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
