import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/contests/contests_list.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: ListView(
        padding: Paddings.pagePadding,
        children: [
          // upcoming contests tile
          getAdminHomeTile(
            'Upcoming Contests',
            Icons.arrow_circle_down,
            Colors.blueAccent,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return ContestsList(
                  ContestsListCubit(),
                  ContestStatuses.upcoming,
                );
              }),
            ),
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