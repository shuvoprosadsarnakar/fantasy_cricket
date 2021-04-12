import 'package:fantasy_cricket/widgets/textfield.dart';
import 'package:flutter/material.dart';

class FantasyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFieldWidget(),
      ))
      
    );
  }
}