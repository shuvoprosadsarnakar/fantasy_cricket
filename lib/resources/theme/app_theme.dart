import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

enum AppTheme {
Light,
Dark,
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorPallate.pomegranate,
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[700],
  ),
};