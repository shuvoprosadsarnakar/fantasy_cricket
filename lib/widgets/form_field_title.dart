import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class FormFieldTitle extends StatelessWidget {
  final String _title;
  
  FormFieldTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        bottom: 5,
      ),
      child: Text(
        _title,
        style: TextStyle(
          color: ColorPallate.ebonyClay,
          fontSize: 18,
        ),
      ),
    );
  }
}
