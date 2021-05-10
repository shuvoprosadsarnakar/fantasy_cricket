import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/pages/home/tabs/fantasy_tab.dart';
import 'package:fantasy_cricket/pages/home/tabs/leaderboard_tab.dart';
import 'package:fantasy_cricket/pages/home/tabs/news_tab.dart';
import 'package:fantasy_cricket/pages/home/tabs/prediction.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallate.pomegranate,
        elevation: 0.0,
        actions: [
          PopupMenuButton<int>(
              onSelected: (value) => _onMenuItemSelected(context, value),
              itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text("Chips")),
                    PopupMenuItem(value: 1, child: Text("Settings")),
                    PopupMenuItem(value: 2, child: Text("Sign out")),
                    PopupMenuItem(value: 3, child: Text("Admin panel"))
                  ])
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: [FantasyTab(), NewsTab(), LeaderboardTab(), PredictionTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(color: ColorPallate.pomegranate),
        unselectedIconTheme: IconThemeData(color: ColorPallate.ebonyClay),
        selectedItemColor: ColorPallate.pomegranate,
        unselectedLabelStyle: TextStyle(color: ColorPallate.ebonyClay),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.whatshot_outlined,
            ),
            label: 'Fantasy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void _onMenuItemSelected(BuildContext context, int value) {
    switch (value) {
      case 0:
        print("Chips clicked");
        break;
      case 1:
        print("Settings clicked");
        break;
      case 2:
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, signIn, (route) => false);
        break;
      case 3:
        Navigator.pushNamed(context, adminHome);
        break;
    }
  }
}
