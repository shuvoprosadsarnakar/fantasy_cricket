import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/my_contests.dart';
import 'package:fantasy_cricket/pages/user/contest/running_contests.dart';
import 'package:flutter/material.dart';

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RunningContests(RunningContestsCubit())
      
    );
  }
}