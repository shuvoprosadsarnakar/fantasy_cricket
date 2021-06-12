import 'package:flutter/material.dart';

class TotalContestants extends StatelessWidget {
  final int totalContestants;

  TotalContestants(this.totalContestants);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.people,
          color: Theme.of(context).primaryColor,  
        ),
        SizedBox(width: 10),
        Text(
          '$totalContestants Contestants',
          style: Theme.of(context).textTheme.subtitle2,  
        ),
      ],
    );
  }
}
