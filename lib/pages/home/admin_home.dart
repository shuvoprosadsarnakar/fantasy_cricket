import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/contests/contests_list.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
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
            Icons.arrow_circle_down_outlined,
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
            Icons.run_circle_outlined,
            Colors.redAccent,
            () {
              Navigator.pushNamed(context, runningContestList);
            },
          ),
          SizedBox(height: 10),

          // locked contests tile
          getAdminHomeTile(
            'Locked Contests',
            Icons.lock_outline,
            Colors.yellow.shade800,
            () {
              Navigator.pushNamed(context, lockedContestList);
            },
          ),
          SizedBox(height: 10),

          // ended contests tile
          getAdminHomeTile(
            'Ended Contests',
            Icons.arrow_circle_up,
            Colors.deepPurpleAccent,
            () {
              Navigator.pushNamed(context, endedContestList);
            },
          ),
          SizedBox(height: 10),
          getAdminHomeTile(
            'Players List',
            Icons.person_outline,
            Colors.cyan,
            () {
              Navigator.pushNamed(context, player);
            },
          ),
          SizedBox(height: 10),
          getAdminHomeTile(
            'Teams List',
            Icons.people_outline,
            Colors.blueGrey,
            () {
              Navigator.pushNamed(context, team);
            },
          ),
          SizedBox(height: 10),
          getAdminHomeTile(
            'Serieses List',
            Icons.file_copy_outlined,
            Colors.teal,
            () {
              Navigator.pushNamed(context, series);
            },
          ),
          SizedBox(height: 10),

          getAdminHomeTile(
            'Exchanges List',
            Icons.money_outlined,
            Colors.green,
            () {
              Navigator.pushNamed(context, exchangesList);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Card getAdminHomeTile(
      String titleText, IconData iconData, Color tileColor, Function onTap) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        tileColor: tileColor,
        leading: Icon(
          iconData,
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          titleText,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            wordSpacing: 1,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
