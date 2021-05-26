import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class FetchErrorMsg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Paddings.pagePadding,
          child: Text(
            'Failed to fetch data from databse.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
