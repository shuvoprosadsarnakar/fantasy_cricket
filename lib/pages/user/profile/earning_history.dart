import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class EarningHistory extends StatelessWidget {
  final User user;

  EarningHistory(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Earning History')),
      body: Padding(
        padding: Paddings.pagePadding,
        child: Column(
          children: [
            getTitles(context),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: user.earningHistory.length,
              itemBuilder: (BuildContext context, int i) {
                return ;
              },
            ),
          ],
        ),
      ),
    );
  }

  Row getTitles(BuildContext context) {
    return Row(children: [
      makeTitle(context, 1, 'Date'),
      SizedBox(width: 10),
      makeTitle(context, 3, 'Date'),
      SizedBox(width: 10),
      makeTitle(context, 1, 'Date'),
      SizedBox(width: 10),
      makeTitle(context, 1, 'Date'),
    ]);
  }

  Expanded makeTitle(BuildContext context, int flex, String title) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,  
      ),
    );
  }
}