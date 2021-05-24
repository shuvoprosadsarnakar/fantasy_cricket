import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/models/win_info.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitlesRow(context),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: user.earningHistory.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(children: [
                  getHistoryRow(user.earningHistory[i]),
                  Divider(),
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitlesRow(BuildContext context) {
    if(user.earningHistory.isEmpty) {
      return Text(
        'No earning history found.',
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else {
      return Row(children: [
        getTitle(context, 1, 'Date'),
        SizedBox(width: 10),
        getTitle(context, 2, 'Details'),
        SizedBox(width: 10),
        getTitle(context, 1, 'Rank'),
        SizedBox(width: 10),
        getTitle(context, 1, 'Rewards'),
      ]);
    }
  }

  Expanded getTitle(BuildContext context, int flex, String title) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,  
      ),
    );
  }

  Row getHistoryRow(WinInfo winInfo) {
    return Row(children: [
      getHistoryContent(1, winInfo.date.toDate().toString().substring(0, 16)),
      SizedBox(width: 10),
      getHistoryContent(2, winInfo.details),
      SizedBox(width: 10),
      getHistoryContent(1, winInfo.rank.toString()),
      SizedBox(width: 10),
      getHistoryContent(1, winInfo.rewards.toString())
    ]);
  }

  Expanded getHistoryContent(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Text(text),
    );
  }
}