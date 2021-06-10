import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  FormSubmitButton({this.title, this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(12),
        primary: Colors.white,
        backgroundColor: ColorPallate.pomegranate,
      ),
      onPressed: onPressed,
    );
  }
}
