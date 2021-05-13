import 'package:fantasy_cricket/pages/user/profile/profile.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      onGenerateRoute: AppRouter.onGenerateRoute,
      //initialRoute: FirebaseAuth.instance.currentUser==null ? signIn : home,
      home: Profile(ProfileCubit()),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.pomegranate,
        accentColor: ColorPallate.pomegranate,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
