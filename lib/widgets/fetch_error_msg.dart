import 'package:flutter/material.dart';

class FetchErrorMsg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text('Failed to fetch data from databse.'),
        ),
      ),
    );
  }
}
