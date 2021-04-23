import 'package:fantasy_cricket/pages/contests/upcoming_contests_list.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // upcoming contests tile
          getAdminHomeTile(
            'Upcoming Contests',
            Icons.arrow_circle_down,
            Colors.blueAccent,
            () => Navigator.pushNamed(context, UpcomingContestsList.routeName),
          ),
          SizedBox(height: 10),

          // running contests tile
          getAdminHomeTile(
            'Running Contests',
            Icons.run_circle,
            Colors.redAccent,
            () {},
          ),
          SizedBox(height: 10),

          // locked contests tile
          getAdminHomeTile(
            'Locked Contests',
            Icons.lock_rounded,
            Colors.yellow.shade800,
            () {},
          ),
          SizedBox(height: 10),

          // ended contests tile
          getAdminHomeTile(
            'Ended Contests',
            Icons.arrow_circle_up,
            Colors.deepPurpleAccent,
            () {},
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Card getAdminHomeTile(String titleText, IconData iconData, Color tileColor,
    Function onTap) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        tileColor: tileColor,
        trailing: Icon(
          iconData,
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          titleText,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}