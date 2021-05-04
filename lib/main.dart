import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/running_contests.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: RunningContests(RunningContestsCubit()),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.pomegranate,
        accentColor: ColorPallate.pomegranate,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
