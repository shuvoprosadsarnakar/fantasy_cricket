import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/pages/home/tabs/first_tab.dart';
import 'package:fantasy_cricket/pages/home/tabs/second_tab.dart';
import 'package:fantasy_cricket/pages/home/tabs/profile_tab.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

final RewardedAd myRewarded = RewardedAd(
  adUnitId: 'ca-app-pub-3940256099942544/5224354917',
  request: AdRequest(),
  listener: AdListener(
    onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print(reward.type);
      print(reward.amount);
    },
  ),
);

  int _selectedPage = 0;
 final List<String> titleList = ["My contests", "Running contests", "Profile"];
 String currentTitle;
  @override
  void initState() {
    currentTitle = titleList[0];
    myRewarded.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
        backgroundColor: ColorPallate.pomegranate,
        elevation: 0.0,
        actions: [
          PopupMenuButton<int>(
              onSelected: (value) => _onMenuItemSelected(context, value),
              itemBuilder: (context) => [
                    PopupMenuItem(value: 3, child: Text("Admin panel")),
                    PopupMenuItem(value: 1, child: Text("Settings")),
                    PopupMenuItem(value: 2, child: Text("Sign out")),
                  ])
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: [FirstTab(), SecondTab(), ProfileTab()],
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
            label: 'Contests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Running',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
      currentTitle = titleList[index];
    });
  }

  void _onMenuItemSelected(BuildContext context, int value) {
    switch (value) {
      case 1:
      myRewarded.show();
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
