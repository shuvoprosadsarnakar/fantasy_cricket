import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class FetchErrorOrMessage extends StatelessWidget {
  final String fetchError = 'Failed to fetch data from databse.';
  final String message;

  FetchErrorOrMessage([ this.message ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: message != null ? EdgeInsets.zero : Paddings.pagePadding,
      child: Text(
        message != null ? message : fetchError,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
