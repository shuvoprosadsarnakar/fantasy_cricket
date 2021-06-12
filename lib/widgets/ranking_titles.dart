import 'package:flutter/material.dart';

class RankingTitles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: Padding(
        padding: EdgeInsets.only(top: 4),
        child: getRankingSingleTitle('Rank'),
      ),
      title: getRankingSingleTitle('User'),
      trailing: getRankingSingleTitle('Points'),
    );
  }

  Text getRankingSingleTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
      ),  
    );
  }
}
